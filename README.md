# MyWorkplace

-- potrebno mi je da razjasnimo šta je (MS SQL Server version 15 compatible)
takva verzija sql servera ne postoji osim ako se misli na build 15.X.XXXX.X 
a to je verzija SQL Server 2019

upitan je kvalitet podataka

1. id i parent_id se ne slažu. ima 63 reda gde ono što je u parent_id ne postoji u id
2. čak i kada isključim ta  63 reda ne mogu da insertujem u tabelu. postoji neki spec karakter koji to ne dozvoljava
3. nisam siguran, ali treba i proveriti da li se slažu latitude i longitude sa poligonom (procedura ne radi baš kako treba). ja nemam dovoljno iskustva sa ovim, možda mi je potreban samo neki hint
4. bekap baze
