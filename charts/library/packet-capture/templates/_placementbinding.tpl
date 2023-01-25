{{- define "library.packetcapture.placementbinding" -}}
{{- if .Values.packetcapture }}
{{- $pcap = .Values.packetcapture }}
---
apiVersion: policy.open-cluster-management.io/v1
kind: PlacementBinding
metadata:
{{- include "packetcapture.labels" $ | indent 2 }}
  name: packet-capture
  namespace: {{- $pcap.namespace }}
placementRef:
  apiGroup: apps.open-cluster-management.io
  kind: PlacementRule
  name: packet-capture
subjects:
- name: packet-capture
  kind: Policy
  apiGroup: policy.open-cluster-management.io
{{- end }}
{{- end }}
{{- end }}

