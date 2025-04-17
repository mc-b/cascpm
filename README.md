# Beispiele zum [CAS Cloud and Platform Manager](https://www.hslu.ch/de-ch/informatik/weiterbildung/technologies-and-methods/cas-cloud/) 

Mit Cloud-Expertise die Digitalisierung mitgestalten.

Quick-Start
-----------

Klont des CAS CPM Repository

    git clone https://github.com/mc-b/cascmp 
    cd cascmp
    
Initialisiert Terraform

    terraform init
    
Erstellt die Infrastruktur

    terraform apply
    
Der DNS-Name und benötigte Links werden am Ende des Erstellungsprozesses ausgegeben.

Clouds
------

Je nach Cloud sind die `source` Einträge zu aktivieren und die anderen zu deaktivieren. Das geschieht durch Löschen oder Voranstellen eines `#`.

Das Anmeldeprozedere ist pro Cloud unterschiedlich. Vor dem Ausführen der Terraform Befehle sind folgende Aktionen durchzuführen.

### AWS

Anmelden bei der AWS Cloud

    aws configure

### Azure

Subscription-Id als Variable `TF_VAR_key` und Resource Groups als `TF_VAR_url` setzen

    export TF_VAR_key="[subscribtion-id]"
    export TF_VAR_url="cascpm"
    az login
    
Bei mehreren Microsoft Accounts ist der `--username` und `--tenant` (oft gleich wie der Username) mitzugeben

    az login --username [USER] --tenant [TENANT]
    
### Google

Einloggen in GCP Cloud

    gcloud auth application-default login
    
Auflisten der aktuellen Projekte (es muss eines ausgewählt werden), setzen als Variable `TF_VAR_url`:
   
    gcloud projects list
    
    export TF_VAR_url="[your-project-id]"    
    gcloud config set project ${TF_VAR_url}
    gcloud auth application-default set-quota-project ${TF_VAR_url}
    
**ACHTUNG**: es ist darauf zu achten, dass der DNS-Name nicht grösser als 64 Zeichen wird, ggf. Hostname kürzen. 

### MAAS.io

Es sind alle drei `TF_VAR` Variablen zu setzen:

    TF_VAR_vpn=default
    TF_VAR_url=http://10.0.24.8:5240/MAAS
    TF_VAR_key=[api-key]
 
### lernmaas

Gleiche Anforderungen wie MAAS.io. 

Im Gegensatz zu MAAS.io, wo nur auf dem KVM-Host mit den meisten Ressourcen VMs erstellt werden, wird auf jedem KVM-Host VMs erstellt.

Die Datei `outputs.tf` bringt Fehler und muss gelöscht werden.

### MultiPath

Es wird ein System mit mindestens 32 GB RAM benötigt. Alle überflüssigen Windows Programme sind zu schliessen.

Ansonsten sind keine Aktionen notwendig. Evtl. ist der Memory Eintrag von 8 auf 6 GB RAM zu vermindern.
 
