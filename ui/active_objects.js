
$(document).ready(function() {
    if (typeof indev !== 'undefined') {
        SyncInventory('[{"item":{"max":2,"usable":true,"equipable":true,"modelid":1241},"name":"wine","quantity":1}]');
    }
});

function UseItem(name) {
    CallEvent('UseItem', name);
}

function EquipItem(name) {
    CallEvent('EquipItem', name);
}

function UnequipItem(name) {
    CallEvent('UnequipItem', name)
}

function DropItem(name) {
    CallEvent('DropItem', name);
}

function SyncInventory(data) {
    console.log(data);
    items = JSON.parse(data);

    // clear inventory slots
    $('.slot').empty();

    // populate slot contents
    $.each(items, function (i, item) {
        i = i + 1;
        let html = `<img src="http://game/objects/${item['modelid']}"></img>`;
        if (item['quantity'] > 1) {
            html = html + `<span class="quantity">${item['quantity']}</span>`;
        }
        html = html + `<div class="options">`;
        if (item['type'] == 'consumable') {
            html = html + `<a onClick="UseItem('${item['name']}')" href="#">Use</a>`;
        } else if (item['type'] == 'wearable') {
            if (item['isequipped']) {
                html = html + `<a onClick="UnequipItem('${item['name']}')" href="#">Unequip</a>`;
            } else {
                html = html + `<a onClick="EquipItem('${item['name']}')" href="#">Equip</a>`;
            }
        }
        html = html + `<a onClick="DropItem('${item['name']}')" href="#">Drop</a>
            </div>
        `;
        $('#slot-'+i).html(html);
    });
}