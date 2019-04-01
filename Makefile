JSONNET_FMT := jsonnet fmt -n 2 --max-blank-lines 2 --string-style s --comment-style s

all: prometheus_alert_rules.yaml lint

fmt:
	find . -name 'vendor' -prune -o -name '*.libsonnet' -print -o -name '*.jsonnet' -print | \
		xargs -n 1 -- $(JSONNET_FMT) -i

prometheus_alert_rules.yaml: mixin.libsonnet lib/alerts.jsonnet alerts/*.libsonnet
	jsonnet -S lib/alerts.jsonnet > $@

lint: prometheus_alert_rules.yaml
	find . -name 'vendor' -prune -o -name '*.libsonnet' -print -o -name '*.jsonnet' -print | \
		while read f; do \
			$(JSONNET_FMT) "$$f" | diff -u "$$f" -; \
		done

	promtool check rules prometheus_alert_rules.yaml

clean:
	rm -rf prometheus_alert_rules.yaml

generate_k8s:
	cd extras; cp manifests/prometheus-rules.yaml .; jb install; ./build.sh example.jsonnet; cd -
	cmp -s extras/prometheus-rules.yaml extras/manifests/prometheus-rules.yaml; \
	RETVAL=$$?; \
	if [ $$RETVAL -eq 0 ]; then \
		echo "Rule files are different"; \
		exit 1; \
	fi
