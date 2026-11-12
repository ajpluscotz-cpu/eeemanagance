# Dashibodi ya Eagle Emergency Security

Mfumo wa usimamizi: walinzi, wateja na mikataba, mahudhurio, malipo.

## Kuweka mfumo (mara moja)
1. supabase.com > New project (jina: eagle-dashibodi). Chagua eneo la karibu (mfano South Africa).
2. SQL Editor > New query > bandika yaliyomo ya `schema.sql` > Run.
3. Authentication > Sign In / Providers > zima "Allow new users to sign up".
4. Authentication > Users > Add user (barua pepe + nenosiri, weka Auto Confirm).
5. Mfanye admin kwa SQL iliyo mwisho wa `schema.sql` (weka barua pepe yako).
6. Project Settings > API: nakili **Project URL** na **anon public key**, ziweke kwenye `config.js`.
   USIWEKE kamwe "service_role" key popote.
7. Authentication > URL Configuration: weka Site URL ya website.

## Majukumu
- `admin` (msimamizi mkuu): anaona na kuhariri kila kitu, pamoja na mikataba na malipo.
- `msimamizi` (wa kituo): anaona walinzi na kuweka mahudhurio tu. Mikataba na malipo vimefichwa kwa sheria za hifadhidata (RLS), si kwa muonekano tu.

## Msimamizi mpya
Tengeneza mtumiaji kwenye Authentication > Users, kisha:
insert into public.profiles (id, full_name, role) select id, 'Jina', 'msimamizi' from auth.users where email = 'barua@pepe';
