# FoodRush — GitHub Pages Edition

This version is **static HTML/CSS/JavaScript** and is designed specifically for GitHub Pages. GitHub Pages cannot execute PHP or MySQL, so the original PHP/MySQL application cannot produce a working GitHub Pages URL.

## GitHub Pages
1. Create a GitHub repository.
2. Upload **all files inside this folder** (not the ZIP itself).
3. Settings → Pages → Deploy from branch → `main` → `/ (root)` → Save.
4. Wait for the deployment, then open the Pages URL.

## Demo admin
- URL: `/admin.html`
- Email: `admin@foodrush.local`
- Password: `password`

The static edition uses localStorage for cart, wishlist, users, orders, theme and demo admin CRUD. It does not require PHP, MySQL or XAMPP.

## PHP/MySQL version
`foodrush.sql` is retained for local XAMPP deployment. For a real server-side production application, use PHP/MySQL hosting rather than GitHub Pages.


### Image fields
Food items support three image formats in the Admin panel:
- **Image URL:** a complete image URL such as an Unsplash URL.
- **Unsplash photo ID:** for example `1568901346375-23c9450c58cd`.
- **Image Path:** a local project path such as `assets/images/foods/burger.jpg`.

If both an Image URL/Unsplash ID and Image Path are supplied, the **Image Path takes priority**. This makes it easy to package images inside the project and deploy them on GitHub Pages.


### Restaurant image fix
When uploading a new restaurant image while editing, the uploaded image now takes priority and automatically clears the previous Image Path so the public Restaurants section immediately shows the new picture.
