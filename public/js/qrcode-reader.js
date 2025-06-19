function onScanSuccess(decodedText) {
    window.location.href = decodedText;
}

const html5QrCode = new Html5Qrcode("reader");

Html5Qrcode.getCameras().then(devices => {
    if (devices && devices.length) {
        html5QrCode.start(
            devices[0].id,
            {
                fps: 10,
                qrbox: {
                    width: 200,
                    height: 200
                }
            },
            onScanSuccess
        );
    }
}).catch(err => {
    console.error("Error al acceder a la cámara", err);
});