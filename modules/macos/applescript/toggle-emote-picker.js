const app = Application("Google Chrome");
app.activate();
const toggle = () => {
  document
    .querySelector('#chatframe')
    .contentWindow
    .document
    .querySelector('yt-live-chat-icon-toggle-button-renderer button')
    .click()
};

const javascript = `(${toggle.toString()})()`;
app.execute(app.windows[0].activeTab, { javascript });

