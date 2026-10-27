# drShine app API (contract v1)

Base URL is configurable in each app. DEV: `https://drshine-production-8tmpnh.laravel.cloud`. Local: `http://127.0.0.1:8030`.

- **Format:** JSON in and out, UTF-8, dates ISO 8601 (`2026-10-26`, `2026-10-26T09:30:00+01:00`).
- **Auth:** `Authorization: Bearer <token>`. Tokens are opaque strings; store them in the platform keychain (`flutter_secure_storage`).
- **Status codes:** `401` means the token is invalid or expired → go to sign-in. `403` means not allowed. `409` means the state doesn't allow it (show `message`). `422` is validation: `{message, errors: {field: [msg]}}`. `429` means too many attempts.

---

## A. drShine app (clinic users) — prefix `/api/app/v1`

### Sign-in
- `POST /login {email, password, device}`
  - → `200 {token, user}`
  - or `200 {two_factor: true, challenge}` (challenge is valid 10 min)
- `POST /login/two-factor {challenge, code}` → `200 {token, user}`. `code` is the 6-digit TOTP or a recovery code.
- `POST /logout` → `204`
- `GET /me` → `{user}`

`user` = `{id, name, email, role, role_label, can_send, clinic: {id, name}}`. `can_send` is true for treating doctors: only they send orders; assistants prepare.

### Patients
- `GET /patients?q=` → `{data: [patient]}`
  - the patients you may see, newest first, max 50
  - `q` searches name and ID
- `POST /patients {first_name, last_name, birth_date?, gender (female|male|other), email?, phone?, country, doctor_id?}` → `201 {patient}`. `doctor_id` defaults to me when I treat.
- `GET /patients/{id}` → `{patient, orders: [order_summary]}`

`patient` = `{id, code, name, first_name, last_name, birth_date, status, status_label, doctor: {id, name}, clinic: {id, name}, is_minor}`.

`order_summary` = `{id, reference, type, type_label, series, status, status_label, journey_label, created_at, submitted_at, draft}`.

### Aligners order (the case builder)
- `POST /orders {patient_id, type: "aligner_series"}` → `201 {order}` (a new draft), or `200 {order}` with the patient's open Aligners draft if there is one
- `GET /orders/{id}` → `{order}` (full state, below)
- `PUT /orders/{id}/plan {kind: complete|flexible, audience: adult|growing}` → `{order}`. Only when `plan_choice.asks` is true.
- `POST /orders/{id}/files` (multipart: `kind`=photo|scan, `slot`, `file`) → `201 {file}`
  - Photos are JPEG or PNG, max 20 MB; scans are `.stl`.
  - Uploading into a slot replaces the slot's file.
- `DELETE /orders/{id}/files/{file}` → `204`
- `GET /orders/{id}/files/{file}` → the file bytes (for thumbnails; send the Bearer token)
- `PUT /orders/{id}/rx {planning_partner, arches, concerns: [], treatment_goal, prescription}` → `{order}`
- `GET /orders/{id}/scans` → `{connected, scans: [{id, source, patient_name, taken_at, jaws: ["upper","lower"], match}]}` (Scan Hub inbox for this patient)
- `POST /orders/{id}/scans/{scan}/import` → `{order}`
- `POST /orders/{id}/submit {attest: ["P1","P2","P3", "K1"?]}` → `{order}`
  - `403` if the user can't send
  - `422` with `missing` if something is missing or a card isn't ticked

`order` (full) = `{`
- `id, reference, type, series, status, status_label, draft, can_send,`
- `steps: [{key: plan|photos|cbct|impressions|rx|submit, label, complete, status}],`
- `plan_choice: {asks, kind, audience},`
- `photos: [{slot, label, group, required, guide, file: {id, name, url} | null}]` — `guide` is a key for the app's own outline drawing, e.g. `frontal-smile`, `occlusal-upper`;
- `scans: [{slot: upper_scan|lower_scan, label, file | null}],`
- `rx: {planning_partner, arches, concerns, treatment_goal, prescription},`
- `options: {partners: [{value, label, description}], arches: [{value, label}], concerns: [{value, label}]},`
- `missing: {step: [text]}, ready,`
- `price_lines: [{label, detail, amount_cents | null}], total_cents,`
- `attestations: [{id, title, text}]`

`}`

Photo slots (`slot` → `label` → `guide`), 18 in total; the first 12 are required for a new case:
- `frontal_smile`, `frontal`, `left_profile_smile`, `left_profile`, `right_profile_smile`, `right_profile` (face)
- `front_arches`, `left_bite`, `right_bite`, `occlusal_upper`, `occlusal_lower`, `overjet` (intraoral)
- `panoramic_xray`, `lateral_cephalometric` (X-ray, optional)
- `left_front_45_smile`, `left_front_45`, `right_front_45_smile`, `right_front_45` (optional)

The API sends `label`, `group` and `required`; the app draws its outline for each `guide`.

---

## B. myShine app (patients) — prefix `/api/myshine/v1`

Without an account the app works offline (smile simulation). The patient links to their clinic with a **connect code** the clinic gives them. The code is 8 characters, shown as `ABCD-2345`, valid for 14 days and usable once. drShine shows it in the Treatment center.

- `POST /connect {code, device}` → `200 {token, patient}`
  - `422` if the code is unknown or expired
  - `429` after too many tries
- `POST /logout` → `204`
- `GET /me` →
  `{`
  - `patient: {first_name, clinic: {name, phone, email, city}, doctor: {name}, status, status_label},`
  - `plan: {shared: bool, url: string | null, series},` — `url` is the Stella viewer link, only when the clinic shared the plan;
  - `therapy: null | {started, series, total, current: {aligner, from, to, days, day}, next_change, ends_on, check_in: {enabled, next_aligner, due_on, late_days}, rows: [{aligner, from, to, days, state: done|now|next}]},`

  `check_in` (added 2026-10-27): whether the doctor chose check-in for this patient when starting therapy. When on, the next aligner change (`next_aligner`, null after the last), its `due_on` date and `late_days` past it (0 when not yet due). Missing means off.
  - `check_ins: [check_in], consents: [{id, status, devices, signed_at, sign_url | null}], unread_messages`

  `}`

  `sign_url` is a short-lived link that opens the consent signing page in the browser, already verified.
- `POST /check-ins {fit: seated|loose|tight|damaged, comfort?: none|mild|strong, notes?}` → `201 {check_in}`. **Since 2026-10-27 a check-in is the patient's aligner change:** the patient confirms they put in `therapy.check_in.next_aligner`; drShine records it on that aligner with its due date, and the schedule follows the day of the change. `409` when the doctor doesn't use check-in for this patient, or after the last aligner. The app no longer sends `wear_hours`.
  - **Photos (added 2026-10-27):** optional intraoral photos, sent as `multipart/form-data` with the same fields plus any of `photos[front]`, `photos[right]`, `photos[left]`, `photos[upper]`, `photos[lower]`. Each is one image (jpeg/png/heic/webp, max 8 MB), and none is required. Without photos the app sends JSON exactly as above. The doctor sees them with that check-in (per step), privately stored.
- `GET /messages` → `{data: [message]}` (newest last; marks the clinic's messages read)
- `POST /messages {body}` → `201 {message}`
  - **Photos (added 2026-10-27):** photos are attachments of a message. `multipart/form-data` with `body` (optional when photos are attached) and `photos[]`: 1 to 3 images (jpeg/png/heic/webp, max 8 MB each). Without photos the app sends JSON exactly as above.

`check_in` = `{id, aligner, aligner_change, due_on, late_days, fit, fit_label, wear_hours, comfort, outcome, outcome_label, source, at, photos}`. `aligner_change` is true for the patient's change from myShine; `late_days` is how many days after `due_on` it came. `photos` is how many were stored (an int; the app also accepts a list and counts it; missing means 0).

`message` = `{id, author: clinic|patient, name, body, at, photos: [{id, url}]}`. `url` is a short-lived private link the app loads directly (like `sign_url`); `photos` missing means none. `body` may be empty when the message has photos.
