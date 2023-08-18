// Variables
var menuOpened = false;
var actualPage = "weapons_card";

// Selecteur
const buttonsPages = document.querySelectorAll(".button_list .catBtn");
const weapons_card = document.getElementById("weapons_card");
const items_card = document.getElementById("items_card");
const container = document.getElementById("container");
const blackmoney = document.getElementById("blackmoney")

const post = (name, data = {}) => {
    const resourceName = GetParentResourceName() || "none";

    fetch(`http://${resourceName}/${name}`, {
        method: "POST",
        headers: {"Content-Type": "application/json"},
        body: JSON.stringify(data)
    })
}

const SetItems = (type, weapons) => {
    
    if (weapons.length < 1) return;

     weapons.map((item, key) => {
        const directory = type === 1 ? "src/image/weapons/" : "src/image/items/";
        const imageUrl = item.image.includes(".png") ? item.image.replace(".png", "") : item.image;

        const card = document.createElement("div");
        card.className = "card";

        const header_card = document.createElement("div");
        header_card.className = "header_card";

        card.appendChild(header_card);

        const title = document.createElement("h1");
        title.innerText = item.label;

        header_card.appendChild(title);

        const category = document.createElement("button");
        category.innerText = item.category;

        header_card.appendChild(category);

        const image_pos = document.createElement("div");
        image_pos.className = "image_pos";

        card.appendChild(image_pos);

        const image_card = document.createElement("div");
        image_card.className = "image_card";
        image_card.style.backgroundImage = `url(${directory}${imageUrl}.png)`;~

        image_pos.appendChild(image_card);

        const paid_menu = document.createElement("div");
        paid_menu.className = "paid_menu";

        card.appendChild(paid_menu);

        const paid_button = document.createElement("button");
        paid_button.className = "paid_button";
        paid_button.innerText = "ACHETER";

        for (const key in item) {
            paid_button.setAttribute(`data-${key}`, item[key]);
        }

        const onClickPay = (event) => {
            post(type === 1 ? "payWeapon" : "payItem", event.target.dataset);
          };

        paid_button.addEventListener("click", onClickPay);

        paid_menu.appendChild(paid_button)

        const paid_number = document.createElement("p");
        paid_number.className = "paid_number";
        paid_number.innerText = `${item.price} $`;

        paid_menu.appendChild(paid_number);

        type === 1 ? weapons_card.appendChild(card) : items_card.appendChild(card);
    });
}

const setBlackMoney = (money) => {
    blackmoney.innerText = money
}

const showMenu = (show) => {
    let cls = container.classList;

    show ? (cls.contains("hide") && cls.remove("hide")) : (!cls.contains("hide") && cls.add("hide"));
    menuOpened = show;
}

const manageButtonPages = (e) => {
    e.preventDefault();
    
    const data = e.target.dataset;
    if (data.page === actualPage) return;
    
    const actualPageDoc = document.getElementById(actualPage);
    const pageDoc = document.getElementById(data.page);
    
    if (actualPageDoc && pageDoc) {
        // on cache la page qu'on a pas sélectionner et on montre l'autre
        actualPageDoc.classList.add("hide");
        pageDoc.classList.remove("hide");
        
        // on gère les buttons armes et items
        buttonsPages.forEach(el => el.classList.contains("active") && el.classList.remove("active"));
        e.target.classList.add("active");
        actualPage = data.page;
    }
}

const manageData = (e) => {
    let event = e.data;

    switch(event.type) {
        case "show":
            showMenu(event.show);
            break;
        case "setWeapons":
            SetItems(1, event.weapons);
            break;
        case "setItems":
            SetItems(2, event.items);
            break;
        case "setMoney":
            setBlackMoney(event.money);
            break
    }
}

const manageKey = (e) => {
    const keyName = e.key.toUpperCase();
    
    if (menuOpened && (keyName === "ESCAPE" || keyName === "E")) {
        post("closeMenu");
    }
}

window.addEventListener("message", manageData);
window.addEventListener("keydown", manageKey);
buttonsPages.forEach(el => el.addEventListener("click", manageButtonPages));