// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import "../css/app.css";
import "../node_modules/materialize-css/dist/js/materialize";
// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import deps with the dep name or local files with a relative path, for example:
//
import { Socket } from "phoenix";
import socket from "./socket";

import "phoenix_html";

document.addEventListener("DOMContentLoaded", function () {
  const btnFloat = document.querySelectorAll(".fixed-action-btn");
  M.FloatingActionButton.init(btnFloat, {});

  const sideNav = document.querySelectorAll('.sidenav');
  M.Sidenav.init(sideNav, {});
});
