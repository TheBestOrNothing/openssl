# Chain of trust
Chain of certificate authorities verification

Certificate Authority - A chain of trust
In reality, there’s a chain of certificate authorities.

At the top level is a root certificate authority, who signs their own certificate, and also signs the certificate of their subordinate, which is an intermediate certificate authority.

This authority can sign the certificate of other intermediate authorities, or they can sign the end-entity certificate (or leaf certificate).

Each certificate will reference back to the certificate of their higher level authority, up to the root.

Your operating systems and browsers store a list of certificates of trusted root certificate authorities. That way they can easily verify the authenticity of all certificates.
