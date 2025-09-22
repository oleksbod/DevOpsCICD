{{- define "django-app.name" -}}
django-app
{{- end }}

{{- define "django-app.fullname" -}}
{{ include "django-app.name" . }}
{{- end }}

{{- define "django-app.chart" -}}
{{ .Chart.Name }}-{{ .Chart.Version }}
{{- end }}
