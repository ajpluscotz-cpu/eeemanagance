(function(){
var d=document,cur=d.documentElement.lang==='en'?'en':'sw';
var links=[].slice.call(d.querySelectorAll('.lang a'));
links.forEach(function(a){a.addEventListener('click',function(){try{localStorage.setItem('ee_lang',a.getAttribute('hreflang'))}catch(e){}})});
var saved=null;try{saved=localStorage.getItem('ee_lang')}catch(e){}
if(saved)return;
var ls=navigator.languages||[navigator.language||''];
var pref=ls.some(function(l){return /^sw/i.test(l)})?'sw':'en';
if(pref===cur)return;
var alt=links.filter(function(a){return a.getAttribute('hreflang')===pref})[0];if(!alt)return;
var T=pref==='en'?['This page is also available in English.','View in English','Close']:['Ukurasa huu unapatikana pia kwa Kiswahili.','Fungua kwa Kiswahili','Funga'];
var b=d.createElement('div');b.className='lb';
var p=d.createElement('span');p.textContent=T[0]+' ';var a=d.createElement('a');a.href=alt.getAttribute('href');a.textContent=T[1];a.setAttribute('hreflang',pref);a.addEventListener('click',function(){try{localStorage.setItem('ee_lang',pref)}catch(e){}});p.appendChild(a);
var x=d.createElement('button');x.type='button';x.setAttribute('aria-label',T[2]);x.innerHTML='&times;';x.addEventListener('click',function(){try{localStorage.setItem('ee_lang',cur)}catch(e){}b.remove()});
b.appendChild(p);b.appendChild(x);d.body.insertBefore(b,d.body.firstChild);
})();
