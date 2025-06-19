let qrdiv = document.getElementById('qr-code');
const accountId = qrdiv.getAttribute("account")

const qrcode = new QRCode(qrdiv, {
    width:200,
    height: 200
})

function generateQR() {
    qrcode.makeCode(`http://localhost:8000/transfers?contact_id=${accountId}`);
}

generateQR()