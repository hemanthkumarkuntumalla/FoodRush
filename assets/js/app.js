/*
 * Local image configuration for GitHub Pages/static hosting.
 * Default images live inside assets/images, so no external image host is required.
 */
const localImage=(folder,file)=>`assets/images/${folder}/${file}`;
const img=(file,w=800)=>localImage('foods',file);
const imageSource=(image,imagePath,w=800,fallback='')=>{
  if(imagePath && String(imagePath).trim()) return String(imagePath).trim();
  if(!image) return fallback || '';
  const value=String(image).trim();
  if(value.startsWith('data:image/')) return value;
  if(value.startsWith('blob:') || value.startsWith('http://') || value.startsWith('https://')) return value;
  if(value.startsWith('/') || value.startsWith('./') || value.startsWith('../') || value.startsWith('assets/')) return value;
  return fallback || '';
};
const categories=['Pizza','Burgers','Biryani','Indian','Chinese','South Indian','Desserts','Beverages','Fast Food','Healthy Food','Cakes','Ice Cream'];
const catPics=[
  'assets/images/categories/pizza.jpg','assets/images/categories/burger.jpg',
  'assets/images/categories/cbiryani.jpg','assets/images/categories/Indian.jpg',
  'assets/images/categories/Chinese.jpg','assets/images/categories/South Indian.jpg',
  'assets/images/categories/Desserts.jpg','assets/images/categories/Beverages.jpg',
  'assets/images/categories/Fast Food.jpg','assets/images/categories/Healthy Food.jpg',
  'assets/images/categories/Cakes.jpg','assets/images/categories/Ice Cream.jpg'
];
const foodPics=[
  'Crazy Crust Pizza.jpg','Teriyaki Burgers.jpg','Lucknowi Biryani.jpg','Chhole (Chickpea Curry).jpg',
  'Egg Noodles.jpg','South Indian Meals.jpg','Mixed Ice Cream.jpg','Portakal Suyu.jpg',
  'French Fries.jpg','Vegetable Salad.jpg','Birthday Cake.jpg','Vanilla ice cream.jpg',
  'Margherita Pizza.jpg','Chicken biryani.jpg','Pasta.jpg','Momo.jpg',
  'Tandoori Chicken.jpg','Sandwich.jpg','Pea & Spinach Carbonara.jpg','Gulab Jamun Thandai Mousse.jpg'
].map(x=>`assets/images/foods/${x}`);
const restaurants=['Spice Route','Urban Bites','The Curry House','Pizza Craft','Tandoori Tales','Wok This Way','South Street','Sweet Truth'];
const restPics=[
  'assets/images/restaurants/Tandoori Tales.jpg',
  'assets/images/restaurants/download (4).jpg',
  'assets/images/restaurants/Air Fryer Whole Tandoori Chicken.jpg',
  'assets/images/restaurants/download (3).jpeg',
  'assets/images/restaurants/Smoky Paneer Tikka Skewers with Mint Chutney - Easy Indian BBQ Favorite.jpg',
  'assets/images/restaurants/panner roll looks tempting #L01fae0.jpg',
  'assets/images/restaurants/Traditional Indian Thali #L01f1ee#L01f1f3 _ Homemade Veg Meal _ Authentic Indian Food Platter.jpg',
  'assets/images/restaurants/Masala Coke.jpg'
];
const cuisines=['Indian','Fast Food','North Indian','Italian','Mughlai','Chinese','South Indian','Desserts'];
let foods=[]; for(let i=1;i<=50;i++){let c=categories[(i-1)%categories.length];foods.push({id:i,name:[c+' Special','Classic '+c,'Chef’s '+c,'Loaded '+c][i%4],cat:c,restaurant:restaurants[(i-1)%restaurants.length],price:Math.round(99+(i*37)%550),rating:(4+(i%10)/10).toFixed(1),discount:i%4===0?20:0,image:foodPics[(i-1)%foodPics.length],imagePath:''});}
const defaultRestaurants=restaurants.map((name,i)=>({id:i+1,name,cuisine:cuisines[i],rating:(4.2+(i%5)/10).toFixed(1),time:(20+i*4)+' min',price:150+i*50,image:restPics[i%restPics.length],imagePath:''}));
const get=(k,d)=>JSON.parse(localStorage.getItem(k)||JSON.stringify(d)); const set=(k,v)=>localStorage.setItem(k,JSON.stringify(v));
const defaultCategories = categories.map((name,i)=>({name,image:catPics[i%catPics.length],imagePath:''}));
function normalizeCategories(raw){
  if(!Array.isArray(raw) || raw.length===0) return defaultCategories.map(x=>({...x}));
  return raw.map((c,i)=>{
    if(typeof c==='string') return {name:c,image:catPics[i%catPics.length],imagePath:''};
    return {name:String(c?.name || c?.title || '').trim(),image:String(c?.image || ''),imagePath:String(c?.imagePath || '')};
  }).filter(c=>c.name);
}
let cart=get('fr_cart',[]),wish=get('fr_wish',[]),users=get('fr_users',[]),orders=get('fr_orders',[]),adminFoods=get('fr_foods',foods),adminCats=normalizeCategories(get('fr_cats',defaultCategories));
if(!localStorage.getItem('fr_foods_seeded') && (!Array.isArray(adminFoods) || adminFoods.length===0)){
  adminFoods=foods.map(x=>({...x}));
  set('fr_foods',adminFoods);
  localStorage.setItem('fr_foods_seeded','true');
}
let rests=get('fr_restaurants',defaultRestaurants);
if(!Array.isArray(rests)||!rests.length) rests=defaultRestaurants.map(x=>({...x}));
rests=rests.map((r,i)=>({...defaultRestaurants[i%defaultRestaurants.length],...r,id:r.id||Date.now()+i,image:r.image??defaultRestaurants[i%defaultRestaurants.length].image,imagePath:r.imagePath||''}));
if(!localStorage.getItem('fr_cats') || !JSON.parse(localStorage.getItem('fr_cats')||'[]').length) set('fr_cats',adminCats);
function save(){set('fr_cart',cart);set('fr_wish',wish);set('fr_foods',adminFoods);set('fr_cats',adminCats);set('fr_restaurants',rests);set('fr_orders',orders);updateCounts()}
function updateCounts(){const c=document.getElementById('cartCount'),w=document.getElementById('wishCount');if(c)c.textContent=cart.reduce((a,x)=>a+x.qty,0);if(w)w.textContent=wish.length}
function scrollToId(id){document.getElementById(id)?.scrollIntoView({behavior:'smooth'})}
function renderCategories(){
  const grid=document.getElementById('categoryGrid');
  if(grid){
    grid.innerHTML=adminCats.map((c,i)=>{
      const fallback=catPics[i%catPics.length];
      const src=imageSource(c.image,c.imagePath,700,fallback)||fallback;
      const safeName=String(c.name).replace(/\\/g,'\\\\').replace(/'/g,"\\'");
      return `<div class="col-6 col-md-3 col-lg-2"><button class="category-card d-block w-100 border-0" onclick="filterCat('${safeName}')"><img src="${src}" alt="${c.name}" onerror="this.src='${fallback}'"><h6 class="mt-3 mb-0">${c.name}</h6></button></div>`;
    }).join('') || '<div class="col-12"><p class="muted">No categories available.</p></div>';
  }
  const s=document.getElementById('catFilter');
  if(s) s.innerHTML='<option value="all">All categories</option>'+adminCats.map(c=>`<option value="${c.name}">${c.name}</option>`).join('');
}
function renderRestaurants(){if(!document.getElementById('restaurantGrid'))return;let s=document.getElementById('sort')?.value||'rating';let a=[...rests].sort((x,y)=>s==='rating'?y.rating-x.rating:s==='time'?parseInt(x.time)-parseInt(y.time):x.price-y.price);document.getElementById('restaurantGrid').innerHTML=a.map((r,i)=>{const fallback=restPics[i%restPics.length];const src=imageSource(r.image,r.imagePath,900,fallback)||fallback;const safeName=JSON.stringify(String(r.name)).replace(/"/g,'&quot;');return `<div class="col-md-6 col-lg-3"><div class="restaurant-card h-100"><img class="restaurant-img" src="${src}" onerror="this.src='${fallback}'"><div class="restaurant-body"><h5 class="fw-bold">${r.name}</h5><p class="muted small">${r.cuisine}</p><span class="rating">★ ${r.rating}</span><span class="muted small ms-2">${r.time}</span><button class="btn btn-brand w-100 mt-3" onclick="restaurantFoods(${safeName})">View Menu</button></div></div></div>`}).join('')}
function renderFoods(){if(!document.getElementById('foodGrid'))return;let f=adminFoods;let c=document.getElementById('catFilter')?.value;if(c&&c!=='all')f=f.filter(x=>x.cat===c);document.getElementById('foodGrid').innerHTML=f.slice(0,50).map(x=>foodCard(x)).join('')}
function foodCard(x){
  let p=x.price*(1-x.discount/100);
  let fallback=foodPics[(Number(x.id||1)-1)%foodPics.length]||foodPics[0];
  let src=imageSource(x.image,x.imagePath,800,fallback)||fallback;
  return `<div class="col-md-6 col-lg-3"><div class="food-card h-100"><img class="food-img" src="${src}" onerror="this.onerror=null;this.src='${fallback}'"><div class="food-body"><div class="d-flex justify-content-between"><h5 class="fw-bold">${x.name}</h5><span class="rating">★${x.rating}</span></div><p class="muted small mb-1">${x.restaurant} · ${x.cat}</p><div class="d-flex justify-content-between align-items-center mt-3"><span class="price">₹${p.toFixed(0)}</span><div><button class="icon-btn me-1" onclick="toggleWish(${x.id})"><i class="fa-${wish.includes(x.id)?'solid':'regular'} fa-heart"></i></button><button class="btn btn-brand btn-sm" onclick="addCart(${x.id})"><i class="fa-solid fa-plus"></i> Add</button></div></div></div></div></div>`;
}
function addCart(id){let x=cart.find(a=>a.id===id);if(x)x.qty++;else cart.push({id,qty:1});save();toast('Added to cart')}
function toggleWish(id){wish=wish.includes(id)?wish.filter(x=>x!==id):[...wish,id];save();renderFoods();toast(wish.includes(id)?'Added to wishlist':'Removed from wishlist')}
function openCart(){let total=cart.reduce((s,a)=>{let f=adminFoods.find(x=>x.id===a.id);return s+f.price*(1-f.discount/100)*a.qty},0);show(`<h3>Your Cart</h3>${cart.length?cart.map(a=>{let f=adminFoods.find(x=>x.id===a.id);return `<div class="d-flex gap-3 align-items-center border-bottom py-3"><img src="${imageSource(f.image,f.imagePath,300,foodPics[(Number(f.id||1)-1)%foodPics.length])||foodPics[(Number(f.id||1)-1)%foodPics.length]}" width="70" height="60" style="object-fit:cover;border-radius:12px"><div class="flex-grow-1"><b>${f.name}</b><div>₹${(f.price*(1-f.discount/100)).toFixed(0)} × ${a.qty}</div></div><button class="btn btn-sm btn-outline-danger" onclick="removeCart(${a.id})">Remove</button></div>`}).join('')+`<h4 class="mt-4">Total: ₹${total.toFixed(0)}</h4><button class="btn btn-brand w-100" onclick="checkout()">Proceed to Checkout</button>`:'<p class="muted">Your cart is empty.</p>'}`)}
function removeCart(id){cart=cart.filter(x=>x.id!==id);save();openCart()}
function openWishlist(){show(`<h3>Wishlist</h3>${wish.length?wish.map(id=>foodCard(adminFoods.find(x=>x.id===id))).join(''):'<p class="muted">No saved items.</p>'}`)}
function checkout(){if(!cart.length)return;show(`<h3>Checkout</h3><input id="name" class="form-control mb-2" placeholder="Full name" required><input id="phone" class="form-control mb-2" placeholder="Phone"><textarea id="address" class="form-control mb-2" placeholder="Delivery address"></textarea><select id="pay" class="form-control mb-3"><option>Cash on Delivery</option><option>UPI</option><option>Credit/Debit Card</option></select><button class="btn btn-brand w-100" onclick="placeOrder()">Place Order</button>`)}
function placeOrder(){let order={id:'FR'+Date.now().toString().slice(-7),date:new Date().toLocaleString(),items:cart,total:cart.reduce((s,a)=>s+adminFoods.find(x=>x.id===a.id).price*a.qty,0),status:'Order Placed',address:document.getElementById('address').value,payment:document.getElementById('pay').value};orders.unshift(order);cart=[];save();show(`<div class="text-center"><i class="fa-solid fa-circle-check display-3 text-success"></i><h3 class="mt-3">Order placed!</h3><p>Your order ID is <b>${order.id}</b></p><button class="btn btn-brand" onclick="showOrders()">Track Order</button></div>`)}
function showOrders(){show(`<h3>My Orders</h3>${orders.length?orders.map(o=>`<div class="glass p-3 mb-3"><b>${o.id}</b><div>${o.date}</div><div class="mt-2"><span class="badge text-bg-success">${o.status}</span></div><div class="small muted mt-2">Placed → Confirmed → Preparing → Out for Delivery → Delivered</div></div>`).join(''):'<p>No orders yet.</p>'}`)}
function openLogin(){show(`<h3>Login</h3><input id="email" class="form-control mb-2" placeholder="Email"><input id="pass" type="password" class="form-control mb-3" placeholder="Password"><button class="btn btn-brand w-100" onclick="login()">Login</button><hr><button class="link-btn" onclick="openRegister()">Create an account</button><div class="small muted mt-3">Demo admin: admin@foodrush.local / password</div>`)}
function openRegister(){show(`<h3>Create account</h3><input id="rname" class="form-control mb-2" placeholder="Full name"><input id="remail" class="form-control mb-2" placeholder="Email"><input id="rpass" type="password" class="form-control mb-3" placeholder="Password"><button class="btn btn-brand w-100" onclick="register()">Register</button>`)}
function register(){
  const user={id:Date.now(),name:rname.value.trim(),email:remail.value.trim().toLowerCase(),password:rpass.value};
  if(users.some(x=>x.email===user.email)){toast('Email already registered');return;}
  users.push(user);set('fr_users',users);
  set('fr_user',{id:user.id,name:user.name,email:user.email});
  closeModal();updateAuthUI();toast('Account created and logged in');
}
function login(){
  if(email.value==='admin@foodrush.local'&&pass.value==='password'){location.href='admin.html';return}
  let u=users.find(x=>x.email===email.value&&x.password===pass.value);
  if(u){set('fr_user',{id:u.id,name:u.name,email:u.email});closeModal();updateAuthUI();toast('Login successful')}
  else toast('Invalid credentials');
}
function foodrushLogout(){
  localStorage.removeItem('fr_user');
  localStorage.removeItem('fr_cart');
  localStorage.removeItem('fr_checkout_user');
  updateAuthUI();
  toast('Logged out');
}
function updateAuthUI(){
  let user=null;
  try{user=JSON.parse(localStorage.getItem('fr_user')||'null')}catch(e){}
  document.querySelectorAll('[data-main-login]').forEach(el=>el.style.display=user?'none':'');
  document.querySelectorAll('[data-main-register]').forEach(el=>el.style.display=user?'none':'');
  document.querySelectorAll('[data-main-logout]').forEach(el=>el.style.display=user?'':'none');
  document.querySelectorAll('[data-fr-login]').forEach(el=>el.style.display=user?'none':'');
  document.querySelectorAll('[data-fr-logout]').forEach(el=>el.style.display=user?'':'none');
  document.querySelectorAll('[data-fr-user]').forEach(el=>el.textContent=user?(user.name||user.email||'Account'):'');
}

function admin(){return JSON.parse(localStorage.getItem('fr_admin')||'false')}
function show(html){const modal=document.getElementById('modal');if(!modal)return;document.body.classList.add('fr-modal-open');modal.hidden=false;modal.innerHTML=`<div class="modal-box" onclick="event.stopPropagation()"><button class="btn-close float-end" aria-label="Close" onclick="closeModal()"></button>${html}</div>`;modal.onclick=function(e){if(e.target===modal)closeModal()}}function closeModal(){const modal=document.getElementById('modal');if(modal)modal.hidden=true;document.body.classList.remove('fr-modal-open')}
function toast(t){let x=document.getElementById('toast');x.textContent=t;x.classList.add('show');setTimeout(()=>x.classList.remove('show'),2200)}function copyCoupon(){navigator.clipboard?.writeText('RUSH20');document.getElementById('couponMsg').textContent='Copied!'}function filterCat(c){location.href='menu.html?cat='+encodeURIComponent(c)}function restaurantFoods(r){location.href='menu.html?restaurant='+encodeURIComponent(r)}function doSearch(){let input=document.getElementById('search');if(!input)return;let q=input.value.toLowerCase();if(location.pathname.endsWith('index.html')||location.pathname.endsWith('/')){location.href='menu.html'+(q?'?q='+encodeURIComponent(q):'');return}let f=adminFoods.filter(x=>(x.name+x.cat+x.restaurant).toLowerCase().includes(q));document.getElementById('foodGrid').innerHTML=f.map(foodCard).join('');scrollToId('menu')}
if(document.getElementById('theme'))document.getElementById('theme').onclick=()=>{document.body.classList.toggle('dark');set('fr_dark',document.body.classList.contains('dark'));document.getElementById('theme').innerHTML=`<i class="fa-solid fa-${document.body.classList.contains('dark')?'sun':'moon'}"></i>`};if(get('fr_dark',false)){document.body.classList.add('dark');if(document.getElementById('theme'))document.getElementById('theme').innerHTML='<i class="fa-solid fa-sun"></i>'}
renderCategories();renderRestaurants();renderFoods();updateCounts();updateAuthUI();

const params=new URLSearchParams(location.search);
const urlQ=params.get('q');
const urlCat=params.get('cat');
const urlRestaurant=params.get('restaurant');
if(urlCat && document.getElementById('foodGrid')){
 const cat=urlCat.toLowerCase();
 const results=adminFoods.filter(x=>x.cat.toLowerCase()===cat);
 document.getElementById('foodGrid').innerHTML=results.map(foodCard).join('');
 const select=document.getElementById('catFilter'); if(select) select.value=adminCats.find(c=>c.toLowerCase()===cat)||urlCat;
 const title=document.getElementById('pageTitle'); if(title) title.textContent=urlCat+' Menu';
}
if(urlRestaurant && document.getElementById('foodGrid')){
 const restaurant=urlRestaurant.toLowerCase();
 const results=adminFoods.filter(x=>(x.restaurant||'').toLowerCase()===restaurant);
 document.getElementById('foodGrid').innerHTML=results.map(foodCard).join('');
 const title=document.getElementById('pageTitle'); if(title) title.textContent=urlRestaurant+' Menu';
}
if(urlQ && document.getElementById('foodGrid')){
 const q=urlQ.toLowerCase();
 const results=adminFoods.filter(x=>(x.name+x.cat+x.restaurant).toLowerCase().includes(q));
 document.getElementById('foodGrid').innerHTML=results.map(foodCard).join('');
 const title=document.getElementById('pageTitle'); if(title) title.textContent='Search results for "'+urlQ+'"';
}
