rm *.pem

# 1. Generate CA's private key and self-signed certificate
openssl req -x509 -newkey rsa:4096 -days 365 -nodes -keyout root-ca-key.pem -out root-ca-cert.pem -subj "/C=FR/ST=Occitanie/L=Toulouse/O=Tech School/OU=Education/CN=*.root.guru/emailAddress=root.guru@gmail.com"

echo "CA's self-signed root certificate"
openssl x509 -in root-ca-cert.pem -noout -text

# 2. Generate intermediate private key and certificate signing request (CSR)
openssl req -newkey rsa:4096 -nodes -keyout intermediate-ca-key.pem -out intermediate-ca-req.pem -subj "/C=FR/ST=Ile de France/L=Paris/O=PC Book/OU=Computer/CN=*.pcbook.com/emailAddress=intermediate@gmail.com"

# 3. Use CA root's private key to sign intermediate's CSR and get back the signed certificate
openssl x509 -req -in intermediate-ca-req.pem -days 60 -CA root-ca-cert.pem -CAkey root-ca-key.pem -CAcreateserial -out intermediate-ca-cert.pem -extfile intermediate-ext.cnf

echo "Server's signed certificate"
openssl x509 -in intermediate-ca-cert.pem -noout -text

# 4. Generate leaf private key and certificate signing request (CSR)
openssl req -newkey rsa:4096 -nodes -keyout leaf-key.pem -out leaf-req.pem -subj "/C=FR/ST=Ile de France/L=Paris/O=PC Book/OU=IT/CN=*.alib.com/emailAddress=leaf@gmail.com"

# 5. Use intermediate CA's private key to sign leaf's CSR and get back the signed certificate
openssl x509 -req -in leaf-req.pem -days 60 -CA intermediate-ca-cert.pem -CAkey intermediate-ca-key.pem -CAcreateserial -out leaf-cert.pem  -extfile leaf-ext.cnf

echo "leaf's signed certificate"
openssl x509 -in leaf-cert.pem -noout -text

# 6. To verify the intermediate CA certification aginst by root CA
echo "intermediate CA's certificate verification"
openssl verify -show_chain -CAfile root-ca-cert.pem intermediate-ca-cert.pem

# 7. To verify the leaf certification aginst by intermediate CA.
echo "leaf's certificate verification"
#openssl verify -show_chain -CAfile intermediate-ca-cert.pem leaf-cert.pem
openssl verify -show_chain -partial_chain -trusted  intermediate-ca-cert.pem leaf-cert.pem

# 8. To verify the chain of all certifications
echo "certificate verification in the chain"
openssl verify -show_chain -CAfile root-ca-cert.pem -untrusted intermediate-ca-cert.pem leaf-cert.pem
