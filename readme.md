<h1>Johns Police Menu</h1>

<h4>Created by notjohnl (Discord)</h4>

<h4>Planned Features</h4>
<ul>
    <li>Add cuffing sounds for when player is cuffed.</li>
    <li>Add cuffing animations.</li>
    <li>Add minigame to allow player a chance to break out of cuffs/drag.</li>
    <li>Can't think of anything else right now (WIP)</li>
</ul>


<h4>Features</h4>

<ul>
    <li>Customizable Loadouts</li>
    <li>Actions</li>
    <ul>
        <li>Cuff/Uncuff</li>
        <li>Drag/Undrag</li>
        <li>Place in Vehicle</li>
        <li>Remove from Vehicle</li>
        <li>Remove Weapons</li>
        <li>Place/Remove Spikestrips</li>
    </ul>
    <li>Commands</li>
    <ul>
        <li>/hu (Puts hands up)</li>
        <li>/handsup (Puts hands up)</li>
        <li>/surrender (Kneels on ground to give self up)</li>
        <li>/kneel (Kneels on ground to give self up)</li>
        <li>/k (Kneels on ground to give self up)</li>
        <li>/openpm (Opens Police Menu)</li>
    </ul>
    <li>Controls</li>
    <ul>
        <li>F9 (Opens Police Menu)</li>
        <li>Players can change the open menu function in their keybind settings.</li>
    </ul>
</ul>


<h4>Changing permissions</h4>
<ul>
<li>If you would like to allow players to use the menu, it is as easy as adding `add_ace identifier.ADDIDENTIFIERHERE policemenu.open allow #PLAYERNAME`</li>
<li>If you would like to allow players to use a loadout, it is as easy as adding `add_ace identifier.ADDIDENTIFIERHERE policemenu.LOADOUTNAME allow #PLAYERNAME`</li>

server.cfg example

```
add_ace identifier.steam:1100001155f7f59 policemenu.open allow #John
add_ace identifier.steam:1100001155f7f59 policemenu.sru allow #John
```

You can also allow groups of players:
```
add_ace group.leo policemenu.open allow
add_ace group.sru policemenu.sru allow
```
</ul>


<h4>Modifying Config</h4>
<ul>
<li>If you would like to add more weapons, simply add the name to the weapons>spawn portion. You can find a full list of weapons in the weapons.lua file.</li>
<li>If you would like to add more attachments, simply add the name of the weapon.attachment. For example: WEAPON_PISTOL.suppressor. You can find a full list of weapon attachments in the weapons.lua file.</li>
<li>Note: I tried my best to make it very straight forward for people that are new to development or have no idea what they are looking at. If you have questions don't be afraid to reach out on discord!</li>
</ul>

<h4>Installation</h4>

<ol>
  <li>Download dpemotes <a href="https://github.com/andristum/dpemotes/releases">here</a>. This is a dependency, you need this for the Police Menu.</li>
  <li>Download johnspolicemenu <a href="https://github.com/chickenlord01/johnspolicemenu">here</a>.</li>
  <li>Extract the folders and upload it to your FiveM server.</li>
  <li>Add the resources to your server.cfg file. (dpemotes before johnspolicemenu)</li>
</ol>

<h4>Credits</h4>

<ul>
  <li>Thanks to BritishBrotherhood for the spikescripts script: <a href="https://forum.cfx.re/t/release-spike-strips-code-updated-09-03-2019/177461">Link</a></li>
  <li>Thanks to Warxander for the menu api: <a href="https://forum.cfx.re/t/release-warmenu-lua-menu-framework/41249">Link</a></li>
  <li>If any bug/issue is found please submit it on the github page.</li>
</ul>