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
  name: "packet-capture-" {{ $cluster.name }}
  namespace: {{ $pcap.namespace }}
spec:
  clusterConditions:
  - status: "True"
    type: ManagedClusterConditionAvailable
  clusterSelector:
    matchExpressions:
      - key: {{ $cluster.label.key }}
        operator: {{ $cluster.label.operator }}
        {{- if $cluster.label.value }}
        values: ["{{ $cluster.label.value }}"]
        {{- end }}
{{- end }}
{{- end }}
{{- end }}
{{- end }}