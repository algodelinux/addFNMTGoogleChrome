#!/bin/bash
#
# Este script añade el certificado de la FNMT a todos los usuarios: alumnos y profesores
# partiendo del directorio home.
# He definido una profundidad de búsqueda máxima y mínima de 3 del directorio  del perfil
# del usuario porque nuestros usuarios se almacenan en /home/profesor/usuario y 
# /home/alumnos/usuario
# El certificado se almacena en el archivo indicado en la variable certificateFile
# 
# Esteban M. Navas Martín
# 02/02/2015

# Se necesita instalar el paquete libnss3-tools para disponer de la herramienta certutil
dpkg -l | grep ^"ii  libnss3-tools" > /dev/null || apt-get -y install libnss3-tools

# Bloque de definición de variables
certificateFile="FNMTClase2CA_FNMT_ES.pem"
certificateName="FNMT Clase 2 CA - FNMT"
certificateRootFile="ACRAIZFNMTRCM.crt"
certificateRootName="AC RAIZ FNMT-RCM"
certificateDB="cert9.db"
homeDir="/home"
depthDir=3

chromeDirs=$(find $homeDir -mindepth $depthDir -maxdepth $depthDir  -type d  -name ".pki" -type d)
for certDB in $(find  ${chromeDirs} -name $certificateDB)
do
  certDir=$(dirname ${certDB});
  echo "Añadiendo certificado $certificateFile a $certDir/$certificateDB"
  certutil -A -n "${certificateName}" -t "CT,c,c" -i ${certificateFile} -d sql:${certDir}
  echo "Añadiendo certificado $certificateRootFile a $certDir/$certificateDB"
  certutil -A -n "${certificateRootName}" -t "CT,C,C" -i ${certificateRootFile} -d sql:${certDir}
done
