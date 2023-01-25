{{- define "library.packet-capture.placementbinding" -}}
{{- if .Values.packet-capture }}
{{- $pcap = .Values.packet-capture }}
---
apiVersion: policy.open-cluster-management.io/v1
kind: PlacementBinding
metadata:
{{- include "packet-capture.labels" $ | indent 2 }}
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

