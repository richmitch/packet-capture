{{- define "library.packetcapture.placementrule" -}}
{{- if .Values.packetcapture }}
{{- $pcap := .Values.packetcapture }}
{{- if .Values.clusters }}
{{- range $cluster := .Values.clusters }}
---
apiVersion: apps.open-cluster-management.io/v1
kind: PlacementRule
metadata:
{{- include "packetcapture.labels" $ | indent 2 }}
  name: packet-capture
  namespace: {{ $pcap.namespace }}
spec:
  clusterConditions:
  - status: "True"
    type: ManagedClusterConditionAvailable
  clusterSelector:
    matchExpressions:
      - key: {{ $pcap.label.key }}
        operator: {{ $pcap.label.operator }}
        values: ["{{ $pcap.label.value | omit }}"]
{{- end }}
{{- end }}
{{- end }}
{{- end }}