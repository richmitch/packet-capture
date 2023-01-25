{{- define "library.packetcapture.placementbinding" -}}
{{- if .Values.packetcapture }}
{{- $pcap := .Values.packetcapture }}
---
apiVersion: policy.open-cluster-management.io/v1
kind: PlacementBinding
metadata:
{{- include "packetcapture.labels" $ | indent 2 }}
  name: packet-capture
  namespace: {{ $pcap.namespace }}
placementRef:
  name: packet-capture
  kind: PlacementRule
  apiGroup: apps.open-cluster-management.io
subjects:
- name: packet-capture
  kind: Policy
  apiGroup: policy.open-cluster-management.io
{{- end }}
{{- end }}

apiVersion: policy.open-cluster-management.io/v1
kind: PlacementBinding
metadata:
  name: packet-capture-ocp001pp002400
placementRef:
  name: packet-capture-ocp001pp002400
  kind: PlacementRule
  apiGroup: apps.open-cluster-management.io
subjects:
- name: deploy-tcpdump-pods
  kind: Policy
  apiGroup: policy.open-cluster-management.io