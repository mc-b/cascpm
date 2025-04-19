# Beispiele zum [CAS Cloud and Platform Manager](https://www.hslu.ch/de-ch/informatik/weiterbildung/technologies-and-methods/cas-cloud/) 

Mit Cloud-Expertise die Digitalisierung mitgestalten.

Quick-Start
-----------

Auf Windows Installiert [Git/Bash](https://git-scm.com/downloads). Auf Linux und Mac bracht es nur `git`.

**ACHTUNG** es muss zwingend [OpenTofu](https://opentofu.org/) verwendet werden.

Klont des CAS CPM Repository

    git clone https://github.com/mc-b/cascmp 
    cd cascmp
    
Initialisiert Terraform

    tofu workspace new [aws|azure|gcp|maas|lernmaas|multipass]
    tofu init
    
Erstellt die Infrastruktur

    tofu apply
    
Der DNS-Name und benötigte Links werden am Ende des Erstellungsprozesses ausgegeben.

**Der OpenTofu Workspace bestimmt die zu verwendente Cloud!** bzw. welcher source Eintrag verwendet wird.

Module - SW Pakete
------------------

Mittels einer Datei `terraform.tfvars` kann festgelegt werden, welche SW Pakete installiert werden.

Beispiel: `main.tfvars` 

    install_cert_manager = "yes"
    install_kubevirt     = "no"
    install_longhorn     = "no"
    install_istio        = "yes"
    install_knative      = "yes"

Oder bei Aufruf von `apply`

    tofu apply \
      -var="install_cert_manager=yes" \
      -var="install_kubevirt=no" \
      -var="install_longhorn=yes" \
      -var="install_istio=no" \
      -var="install_knative=no"

Clouds
------

Das Anmeldeprozedere ist pro Cloud unterschiedlich. Vor dem Ausführen der OpenTofu Befehle sind folgende Aktionen durchzuführen.

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

Gleiche Voraussetzungen wie MAAS.io. 

Aber es werden auf jedem KVM-Host die VMs erstellt.

Der Join des Kubernetes Clusters muss manuell erfolgen.

### Multipass

Es wird ein System mit mindestens 32 GB RAM benötigt. Alle überflüssigen Windows Programme sind zu schliessen.

Ansonsten sind keine Aktionen notwendig. Evtl. ist der Memory Eintrag von 8 auf 6 GB RAM zu vermindern.
 
