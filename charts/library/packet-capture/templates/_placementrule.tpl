{{- define "library.packet-capture.placementrule" -}}
{{- if .Values.packet-capture }}
{{- $pcap = .Values.packet-capture }}
---
apiVersion: apps.open-cluster-management.io/v1
kind: PlacementRule
metadata:
{{- include "packet-capture.labels" $ | indent 2 }}
  name: packet-capture
  namespace: {{- $pcap.namespace }}
spec:
  clusterConditions:
  - status: "True"
    type: ManagedClusterConditionAvailable
  clusterSelector:
    matchExpressions:
      - key: {{-- $pcap.label.key }}
        operator: Equals
        value: {{-- $pcap.label.value }}
{{- end }}
{{- end }}
{{- end }}