{{- define "library.packetcapture.placementbinding" -}}
{{- if .Values.packetcapture }}
{{- $pcap := .Values.packetcapture }}
{{- if .Values.clusters }}
{{- range $cluster := .Values.clusters }}
{{- if .Values.namespaces }}
{{- range $ns := .Values.namespaces }}
{{- if $ns.deployments }}
{{- range $deploy := $ns.deployments }}
---
apiVersion: policy.open-cluster-management.io/v1
kind: PlacementBinding
metadata:
{{- include "packetcapture.labels" $ | indent 2 }}
  name: "pcap-{{ $cluster.name }}-{{ $ns.name }}-{{ $deploy.name }}"
  namespace: {{ $pcap.namespace }}
placementRef:
  name: "packet-capture-{{ $cluster.name }}"
  kind: PlacementRule
  apiGroup: apps.open-cluster-management.io
subjects:
- name: "pcap-{{ $ns.name }}-{{ $deploy.name }}"
  kind: Policy
  apiGroup: policy.open-cluster-management.io
{{- end }}
{{- end }}
{{- end }}
{{- end }}
{{- end }}
{{- end }}
{{- end }}
{{- end }}