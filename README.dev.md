# consultationlist development

See the [project README](./README.md) for the concept and editing workflow.

## Technology stack

- **Frontend:** Vue 3 with TypeScript and plain CSS.
- **Row reordering:** SortableJS via VueDraggablePlus.
- **Date picker:** Native HTML `<input type="date">`.
- **Backend:** Django REST Framework (DRF).
- **Live updates:** A socket connection (e.g. WebSocket) between the devices and the server to track user activity live.
- **Deployment:** Docker containers, with a new image for each release.

## Maintainability

Keep the test suite small and give new contributors a short guide.

- **Backend tests (pytest):** Editors can change rows, but viewers cannot write through the API. When two sessions on the same account request the edit lock at the same time, only one succeeds and only that session can save. Viewers see only published rows until editing ends, then see the saved changes, including row order. Use a controlled clock to test that 30 seconds of inactivity releases the lock, publishes saved drafts and prevents the old session from saving.
- **Frontend test (Vitest):** When another session holds the lock, show the lock message and disable the Edit button. Start with manual browser checks for drag-and-drop and the native date picker.
- **JSON fixtures:** Keep a small set of fictional appointments for local development and tests, including several rows to exercise reordering. Never use real consultation records.
- **CI:** Run pytest, Vitest and `vue-tsc --noEmit`. Add regression tests when bugs reveal gaps rather than aiming for exhaustive coverage.
- **Contributor guide:** Explain how to load the JSON fixtures, run the app and tests locally, understand locking and publishing, and add an appointment field from Django through to Vue.

## Implementation plan

### Phase 1: Foundation

- [x] Decide on the [technology stack](#technology-stack).
- [x] Set up the repository structure, local development environment and basic CI.
- [x] Define the hardcoded table structure and the data model.
- [ ] Build the backend API for listing, adding, editing, deleting and reordering rows.
- [ ] Add simple role handling (editor and viewer) without SSO, e.g. local accounts.

### Phase 2: Frontend and live editing

- [ ] Build the table view for viewers and the editable table for editors, including row sorting.
- [ ] Implement the edit-mode lock: only one device can edit at a time, other devices see a message.
- [ ] Add the socket connection to sync changes live between editors.
- [ ] Release the edit mode after 30 seconds of inactivity and publish the changes to viewers at that point.
- [ ] Add the tests, JSON fixtures and contributor documentation described under [Maintainability](#maintainability).

### Phase 3: Deployment

- [ ] Create Dockerfiles for the frontend and backend.
- [ ] Build and publish a new image for each release.
- [ ] Document how to configure, run and update the deployment.

### Phase 4: SSO and future improvements

- [ ] Add SSO authentication and map users to the editor and viewer roles.
- [ ] Optionally add an admin role for changing the table structure in the frontend.
