# Packet Capture

## Repo structure
### ACM Applications
ACM applications are defined in the 'manifests/acm/applications/' folder, which is referenced by 'manifests/acm/root/root-application.yml' using the App of Apps pattern.  The 'root-application' application will load all applications from the 'manifests/acm/applications' folder.

Each application file in 'manifests/acm/applications/' contains an ACM Application, Subscription and PlacementRule.  The Subscription will reference the Channel and Secret used to access the relevant git repo and the path to where the application components reside within the 'manifests/applications' folder.  The PlacementRule tells ACM which clusters the Application is to be deployed to.

### Applications
The 'manifests/applications' folder includes sub folders that contain the manifests (code & config) to be deployed for the application.