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

See the [developer README](./README.dev.md) for the technology stack, testing and implementation plan.
