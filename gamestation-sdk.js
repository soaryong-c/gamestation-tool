window.parent.postMessage( {type:"gamecenter-request-data"}, '*' );
window.addEventListener( 'message', receiveMsgFromParent );
function receiveMsgFromParent( e ) {
    if (e.data.type == "gamecenter-response-data") {
        window.gamecenter = e.data;
    }
}

function gameCenterSetScore(score) {
    window.parent.postMessage( {type:"gamecenter-set-score", data:score}, '*' );
}

function gameCenterBuyItem(itemId) {
    window.parent.postMessage( {type:"gamecenter-buy-item", data:itemId}, '*' );
}