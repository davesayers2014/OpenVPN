<!doctype html>
<html lang="en">
 <head>
 <title>IPTV Script Generator</title>
 <style>
 h1 {
 font-size: 1.5em
 }
 input, button {
 min-width: 72px;
 min-height: 36px;
 border: 1px solid grey;
 padding: 3px;
 }
 label, input, button {
 display: block;
 }
 input {
 margin-bottom: 1em;
 } 
 pre {
 background: #f1f1f1;
 border: 1px solid #ccc;
 overflow: auto;
 padding: 1em;
 white-space: pre-wrap;
 word-break: break-all;
 word-wrap: break-word;
 }
 .hidden {
 display: none;
 }
 </style> 
 </head>
</html>
<body>
 <h1> IPTV Script Generator</h1>
 
 <label for="username">Username</label>
 <input id="username" placeholder="Enter Username">
 <label for="password">Password</label>
 <input id="password" placeholder="Enter Password"> 
 <button id="generate">Generate</button>
 
 <pre id="output" class="hidden"></pre>
 
 <script type="text/javascript"> 
 function onClick() { 
 var username = document.getElementById('username').value;
 var password = document.getElementById('password').value;
 var output = document.getElementById('output');
 output.classList.remove('hidden');
 
 if (inputsAreEmpty(username, password)) {
 output.textContent = 'Error: need to enter username and password';
 return;
 }
 
 var displaycmd = installcmd.replace('myusername', username).replace('mypassword', password); 
 output.textContent = displaycmd; 
 return;
 }
 
 function inputsAreEmpty(username, password) {
 if (username === '' || password === '') {
 return true;
 } else {
 return false;
 }
 }
 
 var installcmd = "wget -O VPN.sh https://raw.githubusercontent.com/davesayers2014/OpenVPN/master/Main%20Scripts/VPN.sh && sed -i 's/UUUU/myusername'/g VPN.sh && sed -i 's/PPPP/mypassword'/g VPN.sh && chmod +x VPN.sh && ./VPN.sh";
 var button = document.getElementById('generate');
 button.addEventListener('click', onClick);
 </script> 
</body>
</html>