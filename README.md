# Beispiele zum [CAS Cloud and Platform Manager](https://www.hslu.ch/de-ch/informatik/weiterbildung/technologies-and-methods/cas-cloud/) 

Mit Cloud-Expertise die Digitalisierung mitgestalten.

Quick-Start
-----------

Klont des CAS CPM Repository

    git clone https://github.com/mc-b/cascmp 
    cd cascmp
    
Initialisiert Terraform

    terraform init
    
Löscht die Datei `.terraform/modules/master/provider.tf` und Übertragt die AWS Credentials Informationen in die Datei `provider.tf` z.B. mittels Notepad

    notepad provider.tf
    
Erstellt die Infrastruktur

    terraform apply
    
Der DNS-Name und benötigte Links werden am Ende des Erstellungsprozesses ausgegeben.


