# consultationlist

## Concept

We are starting a new project here to do the following:

1. **Consultation table:** We create a table for KuB's daily business of managing legal consultation appointments. The table structure can be hardcoded at first, so it does not need to be changeable in the frontend for now. In the future, we could add an admin user who can change the table structure in the frontend if needed.
2. **Editor role:** An editor can add, edit and delete rows and change the sorting order in the frontend.
3. **Viewer role:** A viewer has view-only permissions.
4. **Authentication:** Later we want to add SSO authentication.
5. **Concurrent editing:** Several devices can be logged in with the same user account. The simplest workflow for now:
   - The user on one device enters the edit mode.
   - All other devices see a message that the edit mode is already active and temporarily not available.
   - Changes are synced live and are visible to all editors on different devices.
   - The edit mode is left after 30 seconds of inactivity.
   - Viewers see the changes only after the editor has left the edit mode.
6. **Deployment:** We use one or several Dockerfiles to containerize the project. Each release creates a new image.

## Technology stack

- **Frontend:** Vue 3 with TypeScript and plain CSS.
- **Row reordering:** SortableJS via VueDraggablePlus.
- **Date picker:** Native HTML `<input type="date">`.
- **Backend:** Django REST Framework (DRF).
- **Live updates:** A socket connection (e.g. WebSocket) between the devices and the server to track user activity live.

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
- [ ] Set up the repository structure, local development environment and basic CI.
- [ ] Define the hardcoded table structure and the data model.
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
