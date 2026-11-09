(function(){
var d=document,$=function(s){return d.querySelector(s)},$$=function(s){return [].slice.call(d.querySelectorAll(s))};
var rm=matchMedia('(prefers-reduced-motion:reduce)').matches;
var L=function(){return d.documentElement.lang==='en'?'en':'sw'};
var t=$('#tg'),l=$('#lk');
t.addEventListener('click',function(){t.setAttribute('aria-expanded',l.classList.toggle('on'))});
l.addEventListener('click',function(e){if(e.target.tagName==='A'){l.classList.remove('on');t.setAttribute('aria-expanded','false')}});
var h=$('header');function sc(){h.classList.toggle('sc',scrollY>40)}
addEventListener('scroll',sc,{passive:true});sc();
var bg=$$('.hbg span'),sl=$$('.sl'),dots=$$('.dots button'),i=0,tm;
if(sl.length){
function go(n){sl[i].classList.remove('on');if(bg[i])bg[i].classList.remove('on');dots[i].classList.remove('on');dots[i].removeAttribute('aria-current');i=(n+sl.length)%sl.length;sl[i].classList.add('on');if(bg[i])bg[i].classList.add('on');dots[i].classList.add('on');dots[i].setAttribute('aria-current','true')}
function stop(){clearInterval(tm)}
function play(){stop();if(!rm)tm=setInterval(function(){go(i+1)},6000)}
dots.forEach(function(b,n){b.addEventListener('click',function(){go(n);play()})});
var hero=$('.hero');['mouseenter','focusin'].forEach(function(e){hero.addEventListener(e,stop)});['mouseleave','focusout'].forEach(function(e){hero.addEventListener(e,play)});
play();
}
function cnt(el){var to=+el.dataset.count;if(rm){el.textContent=to;return}var s=null;requestAnimationFrame(function f(ts){s=s||ts;var p=Math.min((ts-s)/1200,1);el.textContent=Math.round(to*(1-Math.pow(1-p,3)));if(p<1)requestAnimationFrame(f)})}
if('IntersectionObserver' in window){
var io=new IntersectionObserver(function(es){es.forEach(function(e){if(e.isIntersecting){cnt(e.target);io.unobserve(e.target)}})},{threshold:.6});
$$('[data-count]').forEach(function(el){if(!rm)el.textContent='0';io.observe(el)});
}
var f=$('#fm'),er=$('#er');
if(f){
function bad(m,id){er.textContent=m;f.elements[id].focus();return null}
function msg(){var v=function(n){return f.elements[n].value.trim()};
if(v('nm').length<2)return bad(L()==='en'?'Enter your name.':'Andika jina lako.','nm');
if(!/^\+?[0-9 ]{9,15}$/.test(v('ph')))return bad(L()==='en'?'Enter a valid phone number, e.g. 0762 000 000.':'Andika namba ya simu sahihi, mfano 0762 000 000.','ph');
er.textContent='';
return (L()==='en'?'Hello Eagle Emergency Security, my name is '+v('nm')+'. My number: '+v('ph')+'. Service needed: '+v('sv')+'.':'Habari Eagle Emergency Security, naitwa '+v('nm')+'. Namba yangu: '+v('ph')+'. Huduma ninayohitaji: '+v('sv')+'.')+(v('ms')?' '+v('ms'):'')}
$('#wa').addEventListener('click',function(){var m=msg();if(m)open('https://wa.me/255762483386?text='+encodeURIComponent(m),'_blank','noopener')});
$('#em').addEventListener('click',function(){var m=msg();if(m)location.href='mailto:info@eagleemergencysecurity.co.tz?subject='+encodeURIComponent((L()==='en'?'Quote request: ':'Ombi la bei: ')+f.elements.sv.value)+'&body='+encodeURIComponent(m)});
f.addEventListener('submit',function(e){e.preventDefault()});
}
})();
