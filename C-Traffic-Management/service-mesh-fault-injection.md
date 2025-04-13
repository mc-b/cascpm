## Hands-On: Fault Injection mittels Istio

Dieses Hands-On führt dich Schritt für Schritt durch die Fehlerbehebung bei einem fehlerhaften Microservice in einer Istio-verwalteten Umgebung.

---

## **Ziel**
- Identifiziere den fehlerhaften Microservice mithilfe von Istio Telemetry
- Konfiguriere eine Retry-Policy, um die Auswirkung vorübergehender Fehler zu minimieren.
- Optimiere Ressourcen oder Latenzzeiten des betroffenen Services.

---

### **Voraussetzungen**

- Kubernetes-Cluster mit Istio installiert.
- Prometheus und Grafana für Monitoring konfiguriert.
- Eine Anwendung (autoshop-ms) bestehend aus mehreren Microservices, die über Istio verbunden sind.

    kubectl create naamespace ms-rest
    kubectl label  namespace ms-rest istio-injection=enabled


    kubectl apply --namespace ms-rest -f https://gitlab.com/ch-mc-b/autoshop-ms/infra/kubernetes-templates/-/raw/main/3-0-0-deployment/catalog-deployment.yaml
    kubectl apply --namespace ms-rest -f https://gitlab.com/ch-mc-b/autoshop-ms/infra/kubernetes-templates/-/raw/main/3-0-0-deployment/customer-deployment.yaml
    kubectl apply --namespace ms-rest -f https://gitlab.com/ch-mc-b/autoshop-ms/infra/kubernetes-templates/-/raw/main/3-0-0-deployment/order-deployment.yaml
    kubectl apply --namespace ms-rest -f https://gitlab.com/ch-mc-b/autoshop-ms/infra/kubernetes-templates/-/raw/main/3-0-0-deployment/webshop-deployment.yaml 
    kubectl apply --namespace ms-rest -f https://gitlab.com/ch-mc-b/autoshop-ms/infra/kubernetes-templates/-/raw/main/catalog-service.yaml
    kubectl apply --namespace ms-rest -f https://gitlab.com/ch-mc-b/autoshop-ms/infra/kubernetes-templates/-/raw/main/customer-service.yaml
    kubectl apply --namespace ms-rest -f https://gitlab.com/ch-mc-b/autoshop-ms/infra/kubernetes-templates/-/raw/main/order-service.yaml
    kubectl apply --namespace ms-rest -f https://gitlab.com/ch-mc-b/autoshop-ms/infra/kubernetes-templates/-/raw/main/webshop-service.yaml
    kubectl get pod,services --namespace ms-rest
    echo "http://"$(cat ~/work/server-ip)":"$(kubectl get service --namespace ms-rest webshop -o=jsonpath='{ .spec.ports[0].nodePort }')/webshop

Istio unterstützt Fault-Injection zur Simulation von Fehlern (z. B. Latenz oder HTTP-Fehlercodes)

    cat <<EOF | kubectl apply -f - 
    apiVersion: networking.istio.io/v1beta1
    kind: VirtualService
    metadata:
      name: customer-fault-injection
      namespace: ms-rest
    spec:
      hosts:
      - customer.ms-rest.svc.cluster.local
      http:
      - match:
        - sourceLabels:
            app: order
        fault:
          delay:
            percentage:
              value: 50.0 # 50% der Anfragen verzögern
            fixedDelay: 5s # Verzögerung um 5 Sekunden
          abort:
            percentage:
              value: 20.0 # 20% der Anfragen abbrechen
            httpStatus: 500 # Mit HTTP 500 abbrechen
        route:
        - destination:
            host: customer
            port:
              number: 8080
    EOF

---

## **Schritt 1: Identifizierung des fehlerhaften Services** (nicht getestet, funktioniert nur mit Istio Version 1.1x)

### **1.1. Zugriff auf Grafana Dashboard**
1. Logge dich in dein Grafana-Interface ein.
2. Öffne das Istio-Dashboard:
   - Suche nach Dashboards mit Namen wie `Istio Service Dashboard`.
3. Überprüfe die Metriken:
   - **Request Duration**: Identifiziere Services mit ungewöhnlich hohen Antwortzeiten.
   - **HTTP Errors**: Beachte Services mit hoher Fehlerrate (4xx, 5xx).
   - **Request Volume**: Prüfe, ob der Service ungewöhnlich viele Anfragen erhält.

    kubectl get service -n istio-system -l app.kubernetes.io/instance=grafana -o yaml | sed 's/ClusterIP/NodePort/g' | kubectl apply -f -
    echo "Grafana  UI: http://"$(cat ~/work/server-ip)":"$(kubectl get -n istio-system service -l app.kubernetes.io/instance=grafana -o=jsonpath='{ .items[0].spec.ports[0].nodePort }')                                                         

---

### **1.2. Nutzung von Prometheus**

1. Öffne die Prometheus UI.

2. Führe Queries aus, um spezifische Metriken zu überprüfen:
   ```promql
   istio_requests_total{destination_service="webshop.ms-rest.svc.cluster.local"}
   ```
   - Ermittle, welcher Service viele Anfragen oder Fehler zeigt.
   
3. Beispiel für allgemeine Latenzabfragen
   ```promql
   rate(istio_requests_total{destination_service="order.ms-rest.svc.cluster.local"}[5m])
   ```
   Dies zeigt die Anzahl der Anfragen pro Sekunde zum Service an.
   

    kubectl get service -n istio-system -l app.kubernetes.io/name=prometheus -o yaml | sed 's/ClusterIP/NodePort/g' | kubectl apply -f -
    echo "Prometheus   UI: http://"$(cat ~/work/server-ip)":"$(kubectl get -n istio-system service -l app.kubernetes.io/name=prometheus -o=jsonpath='{ .items[0].spec.ports[0].nodePort }')

### 1.3 Jaeger — Tracing

Jaeger ist ein System, um Aufrufe zwischen Microservices zu verfolgen.

Wählt als Service "order.ms-rest" aus und drückt auf "Find Traces"


    kubectl get service -n istio-system -l app=jaeger -o yaml | sed 's/ClusterIP/NodePort/g' | kubectl apply -f -
    echo "Jaeger  UI: http://"$(cat ~/work/server-ip)":"$(kubectl get -n istio-system service/tracing -o jsonpath='{.spec.ports[?(@.name=="http-query")].nodePort}')

### 1.4. Kiali für Visualisierung

1. Öffne Kiali, wenn es installiert ist.
2. Überprüfe die Service-Mesh-Topologie und finde Knoten mit hohen Fehlerraten oder Latenzen.

In der Oberfläche wechselt rechts auf "Graph" und wählt als Namespace "ms-rest" aus.

Mittels Aktivierung der Option "Traffic Animation" im Pulldown "Display" wird die Kommunkation sichtbar

    kubectl get service -n istio-system -l app=kiali  -o yaml | sed 's/ClusterIP/NodePort/g' | kubectl apply -f -
    echo "Kiali   UI: http://"$(cat ~/work/server-ip)":"$(kubectl get -n istio-system service -l app=kiali -o=jsonpath='{ .items[0].spec.ports[0].nodePort }')

### 1.5 Lasttest

Für die Tools benötigen wir Daten, deshalb erzeugen wir ein wenig Traffic für 30 Sekunden


    # LastTest mit 404
    URL="http://"$(cat ~/work/server-ip)":"$(kubectl get service --namespace ms-rest webshop -o=jsonpath='{ .spec.ports[0].nodePort }')/webshop
    hey -z 60s -c 50  ${URL}/order/order

---

## **Schritt 2: Konfiguration einer Retry-Policy** (ab hier nicht getestet!)

### **2.1. Erstelle oder Bearbeite eine VirtualService-Konfiguration**

1. Finde den betroffenen Service in deinem Namespace.
2. Erstelle eine `VirtualService`-Konfiguration mit einer Retry-Policy:

    cat <<EOF | kubectl apply -f - 
       apiVersion: networking.istio.io/v1beta1
       kind: VirtualService
       metadata:
         name: service-name
         namespace: your-namespace
       spec:
         hosts:
         - service-name
         http:
         - retries:
             attempts: 3
             perTryTimeout: 2s
             retryOn: 5xx
           route:
           - destination:
               host: service-name
               port:
                 number: 80
    EOF

---

## **Schritt 3: Optimierung des fehlerhaften Services**

### **3.1. Ressourcenlimits überprüfen und anpassen**

1. Öffne die `Deployment`-Konfiguration des fehlerhaften Services:

       kubectl edit deployment service-name
       
2. Passe Ressourcenanforderungen an:

       resources:
         requests:
           cpu: "100m"
           memory: "128Mi"
         limits:
           cpu: "500m"
           memory: "512Mi"

3. Wende die Änderungen an:

    kubectl apply -f deployment.yaml

---

### **3.2. Readiness- und Liveness-Probes optimieren**

1. Stelle sicher, dass der Service korrekt mit Probes überwacht wird:

       livenessProbe:
         httpGet:
           path: /health
           port: 80
         initialDelaySeconds: 3
         periodSeconds: 10
       readinessProbe:
         httpGet:
           path: /ready
           port: 80
         initialDelaySeconds: 3
         periodSeconds: 10

---

### **3.3. Netzwerklatenz überprüfen**

1. Überprüfe Istio-Mesh-Konfigurationen wie Sidecar-Proxys:

       apiVersion: networking.istio.io/v1beta1
       kind: Sidecar
       metadata:
         name: service-sidecar
         namespace: your-namespace
       spec:
         egress:
         - hosts:
           - "service-name.namespace.svc.cluster.local"

2. Stelle sicher, dass keine unnötigen Regeln die Latenz erhöhen.

    kubectl -n ms-rest get sidecars

---

## **Schritt 4: Überprüfung der Änderungen**

1. Überprüfe erneut die Metriken in Grafana und Prometheus.
2. Führe Tests auf der Anwendung aus, um sicherzustellen, dass die Änderungen wirksam sind.
3. Beobachte, ob die Latenzen und Fehlerraten gesenkt wurden.

---

### **Zusammenfassung**
In diesem Hands-On hast du gelernt, wie du mit Istio und Monitoring-Tools wie Grafana und Prometheus einen fehlerhaften Microservice identifizierst, Retry-Policies konfigurierst und die Ressourcen und Latenzzeiten optimierst.

- - -

Aufräumen

    kubectl delete namespace ms-rest

- - -
### Quellen

* Sourcecode: https://gitlab.com/ch-mc-b/autoshop-ms/app/shop/-/tree/v2.1.0?ref_type=heads
* Kubernetes Deklarationen: https://gitlab.com/ch-mc-b/autoshop-ms/infra/kubernetes-templates
* Container Registry: https://gitlab.com/ch-mc-b/autoshop-ms/app/shop/container_registry



