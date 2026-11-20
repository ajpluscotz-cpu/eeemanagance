(function(){
var U='https://psgueoifgxpcbwisqiun.supabase.co',K='sb_publishable_oDrw6eYSSJj0AwcHRCyJ-Q_5p4gWzmo';
var d=document,en=d.documentElement.lang==='en';
var esc=function(s){var x=d.createElement('div');x.textContent=s==null?'':String(s);return x.innerHTML};
var img=function(p){return U+'/storage/v1/object/public/site-media/'+encodeURI(p)};
function get(q){return fetch(U+'/rest/v1/'+q,{headers:{apikey:K}}).then(function(r){return r.ok?r.json():[]}).catch(function(){return[]})}
var pick=function(o,k){var a=o[k+(en?'_en':'_sw')],b=o[k+(en?'_sw':'_en')];return (a&&a.trim())?a:(b||'')};
var hero=d.querySelector('.hero .sls');
if(hero)get('site_slides?select=*&active=eq.true&order=sort_order.asc,created_at.asc').then(function(rows){
 if(!rows.length)return;
 d.querySelector('.hbg').innerHTML=rows.map(function(r,i){return '<span class="'+(i?'':'on')+'" style="background-image:url(\''+img(r.image_path)+'\')"></span>'}).join('');
 hero.innerHTML=rows.map(function(r,i){var t=esc(pick(r,'title')),p=esc(pick(r,'text'));return '<div class="sl'+(i?'':' on')+'">'+(i?'<div class="hh">'+t+'</div>':'<h1>'+t+'</h1>')+(p?'<p>'+p+'</p>':'')+'</div>'}).join('');
 d.querySelector('.dots').innerHTML=rows.map(function(r,i){return '<button'+(i?'':' class="on" aria-current="true"')+' aria-label="'+(en?'Slide ':'Slaidi ')+(i+1)+'"></button>'}).join('');
 if(window.eeInitHero)window.eeInitHero();
});
var box=d.getElementById('posts'),det=d.getElementById('post');
if(box&&det)get('posts?select=*&published=eq.true&order=created_at.desc').then(function(rows){
 if(!rows.length)return;
 var t0=d.title,more=en?'Read more':'Soma zaidi',loc=en?'en-GB':'sw';
 box.innerHTML=rows.map(function(r){var b=pick(r,'body');return '<a class="card" href="#'+r.id+'" style="padding:0;overflow:hidden">'+(r.image_path?'<img class="pimg" style="border:0;height:240px" src="'+img(r.image_path)+'" alt="'+esc(pick(r,'title'))+'" loading="lazy">':'')+'<div style="padding:28px"><h3>'+esc(pick(r,'title'))+'</h3><p>'+esc(b.length>140?b.slice(0,140)+'...':b)+'</p><p class="more">'+more+'</p></div></a>'}).join('');
 function show(){var id=location.hash.slice(1),r=rows.filter(function(x){return x.id===id})[0];
  if(!r){det.hidden=true;box.hidden=false;d.title=t0;return}
  box.hidden=true;det.hidden=false;
  det.innerHTML='<p><a href="#" style="color:var(--ac);font-weight:600">&larr; '+(en?'Back to articles':'Rudi kwenye makala')+'</a></p><h2>'+esc(pick(r,'title'))+'</h2><p style="color:var(--dim)">'+esc(new Date(r.created_at).toLocaleDateString(loc,{year:'numeric',month:'long',day:'numeric'}))+'</p>'+(r.image_path?'<img class="pimg wide" src="'+img(r.image_path)+'" alt="'+esc(pick(r,'title'))+'">':'')+'<div style="max-width:760px;margin-top:24px">'+pick(r,'body').split(/\n+/).filter(Boolean).map(function(p){return '<p>'+esc(p)+'</p>'}).join('')+'</div>';
  d.title=pick(r,'title')+' | Eagle Emergency Security Ltd';window.scrollTo(0,0)}
 addEventListener('hashchange',show);show();
});
})();
