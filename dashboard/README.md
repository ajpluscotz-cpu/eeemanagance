# Dashibodi ya Eagle Emergency Security

Mfumo wa usimamizi: walinzi, wateja na mikataba, mahudhurio, nukuu za bei, ankara, hati za kukabidhi, risiti, stoo, na mipangilio ya kampuni (benki na pesa ya simu).

## Kuweka mfumo (mara moja)
1. supabase.com > New project (jina: eagle-dashibodi). Chagua eneo la karibu (mfano South Africa).
2. SQL Editor > New query > bandika yaliyomo ya `schema.sql` > Run. (Ni salama kuiendesha tena baada ya kila sasisho la mfumo.)
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

## Nyaraka
Mipangilio > weka jina la kampuni, TIN, benki na pesa ya simu; zitaonekana kwenye nukuu na ankara. Kila nyaraka ina namba ya kiotomatiki (QT-, INV-, DN-, RCT-) na inachapishwa/kuhifadhiwa PDF kwa kitufe cha "Chapisha / Pakua PDF".
Mtiririko: Nukuu > Ankara > Pokea malipo (Risiti) > Hati ya Kukabidhi. Nyaraka zilizotolewa zinaghairiwa kwanza kabla ya kufutwa.

## Slideshow na Matangazo (website)
Kwenye menyu ya msimamizi mkuu: "Slideshow ya Website" (pakia picha na maandishi ya slaidi za ukurasa wa nyumbani) na "Matangazo (Blogs)" (habari zinazoonekana kwenye ukurasa wa Makala). Picha zinapunguzwa ukubwa zenyewe kabla ya kupakiwa. Endesha `schema.sql` tena ili kuunda jedwali na hifadhi ya picha (`site-media`).
