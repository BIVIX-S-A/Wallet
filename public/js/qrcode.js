let qrdiv = document.getElementById('qr-code');
const accountId = qrdiv.getAttribute("account")

var qrcode = new QRCode(qrdiv, {
    width:200,
    height: 200,
    colorDark : "#8376f5",
    colorLight : "#f5f7ff",
    correctLevel : QRCode.CorrectLevel.H
})

function generateQR() {
    qrcode.clear()
    qrcode.makeCode(`http://localhost:8000/transfers?contact_id=${accountId}`);
}

generateQR()