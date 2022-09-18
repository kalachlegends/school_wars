// We import the CSS which is extracted to its own file by esbuild.


import '../scss/style.scss'


// If you want to use Phoenix channels, run `mix help phx.gen.channel`
// to get started and then uncomment the line below.
// import "./user_socket.js"

// You can include dependencies in two ways.
//
// The simplest option is to put them in assets/vendor and
// import them using relative paths:
//
//     import "../vendor/some-package.js"
//
// Alternatively, you can `npm install some-package --prefix assets` and import
// them using a path starting with the package name:
//
//     import "some-package"
//

// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html"
// Establish Phoenix Socket and LiveView configuration.
import { Socket } from "phoenix"
import { LiveSocket } from "phoenix_live_view"
import topbar from "../vendor/topbar"


let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let liveSocket = new LiveSocket("/live", Socket, { params: { _csrf_token: csrfToken } })

// Show progress bar on live navigation and form submits
topbar.config({ barColors: { 0: "#29d" }, shadowColor: "rgba(0, 0, 0, .3)" })
window.addEventListener("phx:page-loading-start", info => topbar.show())
window.addEventListener("phx:page-loading-stop", info => topbar.hide())

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket
import $ from "jquery";

import Swal from 'sweetalert2/dist/sweetalert2.js'
globalThis.$ = $;
globalThis.Swal = Swal;

// DROP DOWN 

$(document).ready(function () {

    $('.header_burger ').click(function (event) {
        $('.header_burger,.nav,.header').toggleClass('active');
        $('body').toggleClass('lock');
    });



    $(".drop-down").click(function (event) {
        let title = this.querySelector(".title-dropdown"),
            submenu = this.querySelector(".drop-down__submenu"),
            originalEvent = event.originalEvent,
            text

        if (originalEvent.path[1].className == "drop-down__item") text = originalEvent.path[1].textContent
        if (originalEvent.path[2].className == "drop-down__item") text = originalEvent.path[2].textContent

        if (originalEvent.path[1].className == "drop-down__item" ||
            originalEvent.path[2].className == "drop-down__item") {
            title.textContent = text
        }
        submenu.classList.toggle("active")

    })
});