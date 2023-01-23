# Application: Packet Capture
The Packet Capture allocation is an ACM Governance `ConfigurationPolicy` based appliction for enabling and disabling PCAP packet capture from `Pods` in `ManagedClusters`.  The `ConfigurationPolicies` create `Pods` that are attached to any `Pod` running under the target `Deployment`.

@richmitch - Need to work out whether this is possible to do without interrogating the cluster to get the pod names