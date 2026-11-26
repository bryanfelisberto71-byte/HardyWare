-- ============================================================
-- HARDYWARE KEY SYSTEM — jnkie.com | Script ID: 47876
-- ============================================================
local _HW_SCRIPT_ID = "47876"
local _HW_KEY_FILE  = "HardyWare_key.txt"
local _HW_GETKEY_URL= "https://jnkie.com/get-key/hardyware"
local _HW_API_URL   = "https://api.jnkie.com/api/scripts/validate/"

local function hwHttpGet(url)
    local ok,res = pcall(function() return game:HttpGet(url,true) end)
    return ok and res or nil
end

local function hwValidateKey(key)
    if type(key)~="string" or #key<4 then return false end
    local url = _HW_API_URL.._HW_SCRIPT_ID.."/"..key
    local res = hwHttpGet(url)
    if not res then return false end
    -- jnkie retorna JSON: {"valid":true} ou {"valid":false}
    return res:find('"valid":true') ~= nil
end

local function hwLoadKey()
    if type(isfile)=="function" and type(readfile)=="function" then
        if isfile(_HW_KEY_FILE) then
            local k = readfile(_HW_KEY_FILE)
            if k and #k>4 then return k:match("^%s*(.-)%s*$") end
        end
    end
    return nil
end

local function hwSaveKey(key)
    if type(writefile)=="function" then
        pcall(writefile,_HW_KEY_FILE,key)
    end
end

-- ---- GUI de key ----
local function hwShowKeyUI(onSuccess)
    local HS  = game:GetService("HttpService")
    local UIS = game:GetService("UserInputService")
    local TS  = game:GetService("TweenService")
    local sg  = Instance.new("ScreenGui")
    sg.Name   = "HWKeyUI"
    sg.ResetOnSpawn = false
    sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    sg.DisplayOrder = 999
    pcall(function() sg.Parent = game:GetService("CoreGui") end)
    if not sg.Parent then sg.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui") end

    -- fundo escuro
    local bg = Instance.new("Frame",sg)
    bg.Size=UDim2.new(1,0,1,0) bg.BackgroundColor3=Color3.new(0,0,0)
    bg.BackgroundTransparency=0.45 bg.BorderSizePixel=0

    -- janela central
    local win2=Instance.new("Frame",sg)
    win2.Size=UDim2.new(0,380,0,230) win2.AnchorPoint=Vector2.new(0.5,0.5)
    win2.Position=UDim2.new(0.5,0,0.5,0) win2.BackgroundColor3=Color3.fromRGB(18,18,24)
    win2.BorderSizePixel=0
    local wc=Instance.new("UICorner",win2) wc.CornerRadius=UDim.new(0,14)
    local ws=Instance.new("UIStroke",win2) ws.Color=Color3.fromRGB(160,80,255) ws.Thickness=1.5

    -- título
    local ttl=Instance.new("TextLabel",win2)
    ttl.Size=UDim2.new(1,0,0,38) ttl.BackgroundTransparency=1
    ttl.Text="🔑  HardyWare — Key System" ttl.TextColor3=Color3.new(1,1,1)
    ttl.Font=Enum.Font.GothamBlack ttl.TextSize=15 ttl.TextXAlignment=Enum.TextXAlignment.Center

    -- subtítulo
    local sub=Instance.new("TextLabel",win2)
    sub.Size=UDim2.new(1,-30,0,20) sub.Position=UDim2.new(0,15,0,36)
    sub.BackgroundTransparency=1 sub.TextColor3=Color3.fromRGB(160,160,180)
    sub.Font=Enum.Font.Gotham sub.TextSize=11 sub.TextXAlignment=Enum.TextXAlignment.Left
    sub.Text="Cole sua key abaixo. Não tem? Clique em Obter Key."

    -- input box
    local box=Instance.new("TextBox",win2)
    box.Size=UDim2.new(1,-30,0,38) box.Position=UDim2.new(0,15,0,70)
    box.BackgroundColor3=Color3.fromRGB(28,28,38) box.BorderSizePixel=0
    box.Text="" box.PlaceholderText="HW-xxxx-xxxx-xxxx"
    box.TextColor3=Color3.new(1,1,1) box.PlaceholderColor3=Color3.fromRGB(100,100,120)
    box.Font=Enum.Font.GothamMedium box.TextSize=13 box.ClearTextOnFocus=false
    local bc=Instance.new("UICorner",box) bc.CornerRadius=UDim.new(0,8)
    local bs=Instance.new("UIStroke",box) bs.Color=Color3.fromRGB(100,60,200) bs.Thickness=1

    -- status
    local status=Instance.new("TextLabel",win2)
    status.Size=UDim2.new(1,-30,0,20) status.Position=UDim2.new(0,15,0,114)
    status.BackgroundTransparency=1 status.TextColor3=Color3.fromRGB(180,100,255)
    status.Font=Enum.Font.Gotham status.TextSize=11 status.TextXAlignment=Enum.TextXAlignment.Left
    status.Text=""

    local function mkBtn(text,col,px,pw)
        local b=Instance.new("TextButton",win2)
        b.Size=UDim2.new(0,pw,0,36) b.Position=UDim2.new(0,px,0,152)
        b.BackgroundColor3=col b.Text=text
        b.TextColor3=Color3.new(1,1,1) b.Font=Enum.Font.GothamBold b.TextSize=12
        b.AutoButtonColor=false b.BorderSizePixel=0
        local c2=Instance.new("UICorner",b) c2.CornerRadius=UDim.new(0,8)
        b.MouseEnter:Connect(function() TS:Create(b,TweenInfo.new(0.12),{BackgroundTransparency=0.25}):Play() end)
        b.MouseLeave:Connect(function() TS:Create(b,TweenInfo.new(0.12),{BackgroundTransparency=0}):Play() end)
        return b
    end

    local btnGet    = mkBtn("Obter Key",Color3.fromRGB(90,50,180),15,155)
    local btnVerify = mkBtn("Verificar",Color3.fromRGB(130,60,220),180,80)
    local btnPaste  = mkBtn("Colar",Color3.fromRGB(50,50,70),268,52)
    local btnClose  = mkBtn("×",Color3.fromRGB(180,40,60),336,28)
    btnClose.Position=UDim2.new(1,-38,0,8) btnClose.Size=UDim2.new(0,28,0,28)

    btnGet.MouseButton1Click:Connect(function()
        pcall(function() game:GetService("GuiService"):OpenBrowserWindow(_HW_GETKEY_URL) end)
    end)

    btnPaste.MouseButton1Click:Connect(function()
        local ok2,clip=pcall(function() return UIS:GetClipboard() end)
        if ok2 and clip and #clip>0 then box.Text=clip end
    end)

    btnClose.MouseButton1Click:Connect(function() sg:Destroy() end)

    local checking=false
    btnVerify.MouseButton1Click:Connect(function()
        if checking then return end
        local key=box.Text:match("^%s*(.-)%s*$")
        if #key<4 then status.TextColor3=Color3.fromRGB(255,80,80) status.Text="Key muito curta." return end
        checking=true
        status.TextColor3=Color3.fromRGB(180,100,255) status.Text="Verificando..."
        btnVerify.Text="..." btnVerify.Active=false
        task.spawn(function()
            local valid=hwValidateKey(key)
            checking=false
            btnVerify.Text="Verificar" btnVerify.Active=true
            if valid then
                hwSaveKey(key)
                status.TextColor3=Color3.fromRGB(80,220,120) status.Text="✓ Key válida! Carregando..."
                task.wait(0.8)
                sg:Destroy()
                onSuccess()
            else
                status.TextColor3=Color3.fromRGB(255,80,80) status.Text="✗ Key inválida ou expirada."
            end
        end)
    end)
end

-- ---- Ponto de entrada ----
local function hwBoot(onSuccess)
    local saved=hwLoadKey()
    if saved then
        local valid=hwValidateKey(saved)
        if valid then onSuccess() return end
    end
    hwShowKeyUI(onSuccess)
end

-- Envolve o resto do script num callback — só roda se key OK
local __hwBootDone=false
hwBoot(function() __hwBootDone=true end)
-- aguarda a verificação (máx 60s)
local __hwT=0
repeat task.wait(0.1) __hwT=__hwT+0.1 until __hwBootDone or __hwT>=60
if not __hwBootDone then return end -- key não validada em 60s, aborta
-- ============================================================
-- FIM DO KEY SYSTEM — hub carrega abaixo
-- ============================================================
-- Guard: mata execucao anterior antes de qualquer hook
if _G.__HardyWareUnload then pcall(_G.__HardyWareUnload) _G.__HardyWareUnload=nil task.wait(0.08) end
local Players=game:GetService("Players")local UserInputService=game:GetService("UserInputService")local RunService=game:GetService("RunService")local CoreGui=game:GetService("CoreGui")local Debris=game:GetService("Debris")local TweenService=game:GetService("TweenService")local HttpService=game:GetService("HttpService")local Stats=game:GetService("Stats")local player=Players.LocalPlayer local camera=workspace.CurrentCamera local RS=game:GetService("ReplicatedStorage")local RS_Modules=RS:FindFirstChild("Modules")local RS_Net=RS_Modules and RS_Modules:FindFirstChild("Net")local RS_RegisterHit=RS_Net and RS_Net:FindFirstChild("RE/RegisterHit")local RS_RegisterAttack=RS_Net and RS_Net:FindFirstChild("RE/RegisterAttack")local KC_W,KC_A,KC_S,KC_D=Enum.KeyCode.W,Enum.KeyCode.A,Enum.KeyCode.S,Enum.KeyCode.D
-- Compat entre executores: usa o que existir e nao derruba o script nos ruins.
local DW_unpack=table.unpack or unpack
local task=task
if not task then
	task={}
	task.wait=wait
	task.spawn=function(f,...)local co=coroutine.create(f)coroutine.resume(co,...)return co end
	task.delay=function(t,f,...)local a={...}local co=coroutine.create(function()wait(t)f(DW_unpack(a))end)coroutine.resume(co)return co end
	task.defer=task.spawn
else
	if not task.defer then task.defer=task.spawn end
	if not task.delay then task.delay=function(t,f,...)local a={...}local co=coroutine.create(function()wait(t)f(DW_unpack(a))end)coroutine.resume(co)return co end end
end
local DW_hookfunction
do
	local hf=hookfunction or hookfunc or replaceclosure or detourfunction or hook_function
	if type(hf)=="function" then
		DW_hookfunction=function(target,hook)return hf(target,hook)end
	else
		DW_hookfunction=function()return false end
	end
end
local DW_getrawmetatable=getrawmetatable or get_raw_metatable or (debug and debug.getmetatable)
local DW_setreadonly=setreadonly or make_writeable or makewriteable or set_readonly
local DW_getnamecallmethod=getnamecallmethod or get_namecall_method
local DW_newcclosure
do
	local nc=newcclosure or new_cclosure or newcclosured
	if type(nc)=="function" then
		DW_newcclosure=function(f)
			local ok,c=pcall(nc,f)
			if ok and type(c)=="function" then return c end
			return f
		end
	else
		DW_newcclosure=function(f)return f end
	end
end
local DW_hookmetamethod=hookmetamethod or hook_metamethod
local DW_getfpscap=getfpscap or get_fpscap or get_fps_cap or getfpslimit or get_fps_limit
local DW_setfpscap=setfpscap or set_fpscap or set_fps_cap or setfpslimit or set_fps_limit
local DW_getfflag=getfflag or get_fflag or getfastflag or get_fast_flag
local DW_setfflag=setfflag or set_fflag or setfastflag or set_fast_flag
-- Flags: alguns executores querem o nome completo (DFIntX), outros sem prefixo (X). Tenta os dois e confere por leitura.
local DW_FLAG_PREFIXES={"DFFlag","DFInt","DFString","DFLog","FFlag","FInt","FString","FLog","SFFlag","SFInt"}
local function DW_flagStrip(n)
	for i=1,#DW_FLAG_PREFIXES do
		local pf=DW_FLAG_PREFIXES[i]
		if n:sub(1,#pf)==pf and #n>#pf then return n:sub(#pf+1) end
	end
	return n
end
local function DW_flagEq(a,b)
	if a==nil or b==nil then return false end
	local sa,sb=string.lower(tostring(a)),string.lower(tostring(b))
	if sa==sb then return true end
	local na,nb=tonumber(sa),tonumber(sb)
	return na~=nil and nb~=nil and na==nb
end
local function DW_readFlag(name)
	if type(DW_getfflag)~="function" then return nil,nil end
	local variants={name}
	local st=DW_flagStrip(name)
	if st~=name then variants[2]=st end
	for i=1,#variants do
		local ok,v=pcall(DW_getfflag,variants[i])
		if ok and v~=nil and tostring(v)~="" then return v,variants[i] end
	end
	return nil,nil
end
-- retorna ok, status, nomeUsado   status: "confirmado" | "aplicado (sem leitura)" | motivo da falha
local function DW_applyFlag(name,value)
	if type(DW_setfflag)~="function" then return false,"setfflag indisponivel" end
	if type(value)=="boolean" then value=value and "True" or "False" else value=tostring(value) end
	local variants={name}
	local st=DW_flagStrip(name)
	if st~=name then variants[2]=st end
	local lastErr="falhou"
	for i=1,#variants do
		local vn=variants[i]
		local ok,err=pcall(DW_setfflag,vn,value)
		if ok then
			if type(DW_getfflag)=="function" then
				local gok,cur=pcall(DW_getfflag,vn)
				if gok and cur~=nil and tostring(cur)~="" then
					if DW_flagEq(cur,value) then return true,"confirmado",vn end
					lastErr="ignorado pelo Roblox (fora da allowlist)"
				else
					return true,"aplicado (sem leitura)",vn
				end
			else
				return true,"aplicado (sem leitura)",vn
			end
		else
			lastErr=tostring(err)
		end
	end
	return false,lastErr
end
-- Streamproof: "iniciar oculto" (sem som de loader, sem hub aberto, sem notificacoes)
local DW_streamStart=false
pcall(function()
	if type(isfile)=="function" and type(readfile)=="function" and isfile("HardyWareStream.txt") and readfile("HardyWareStream.txt")=="1" then DW_streamStart=true end
end)
local function DW_getnetworkping()
	local ok,v=pcall(function()return player:GetNetworkPing()end)
	if ok and type(v)=="number" then return v*1000 end
	return nil
end
local function DW_safe_gui_parent()
	local p
	pcall(function()if gethui then p=gethui()end end)
	if not p then pcall(function()p=CoreGui end) end
	if not p then pcall(function()p=player:WaitForChild("PlayerGui",10)end) end
	if not p then pcall(function()p=player:FindFirstChildOfClass("PlayerGui")end) end
	return p
end
task.spawn(function()
	if DW_streamStart then return end
	local SoundService = game:GetService("SoundService")
	local snd = Instance.new("Sound")
	snd.Name = "HardyWareLoader"
	snd.SoundId = "rbxassetid://119131244715154"
	snd.Volume = 20
	snd.Looped = false
	snd.Parent = SoundService
	local t0 = os.clock()
	while not snd.IsLoaded and os.clock() - t0 < 5 do task.wait() end
	snd:Play()
	snd.Ended:Connect(function() snd:Destroy() end)
	task.delay(15, function() if snd and snd.Parent then snd:Destroy() end end)
end)
xpcall(function()local guiParent=DW_safe_gui_parent() if not guiParent then guiParent=player:FindFirstChildOfClass("PlayerGui") end for _,n in ipairs({"HardyWare","HardyWareHub"})do local e=guiParent and guiParent:FindFirstChild(n)if e then e:Destroy()end end
local C={Bg=Color3.fromRGB(5,10,24),Header=Color3.fromRGB(8,16,38),Surface=Color3.fromRGB(14,28,62),Track=Color3.fromRGB(28,50,102),Border=Color3.fromRGB(70,130,255),Pink=Color3.fromRGB(46,116,255),PinkSoft=Color3.fromRGB(130,180,255),Accent=Color3.fromRGB(90,160,255),White=Color3.fromRGB(240,246,255),Gray=Color3.fromRGB(170,190,225),Muted=Color3.fromRGB(110,135,185),Red=Color3.fromRGB(255,84,100),Green=Color3.fromRGB(120,235,150),}
local function round(p,r)local c=Instance.new("UICorner")c.CornerRadius=UDim.new(0,r)c.Parent=p end
local function line(p,col,th,tr)local s=Instance.new("UIStroke")s.Color=col s.Thickness=th or 1 s.Transparency=tr or 0.35 s.ApplyStrokeMode=Enum.ApplyStrokeMode.Border s.Parent=p end
local Languages={["pt"]={tab_pvp="PVP",tab_soru="Soru",tab_glitch="Glitch V2",tab_fly="Fly",tab_gun="Gun",tab_fps="Fps",tab_camera="Camera",cam_title="Glitches de Camera",stretch_cam="Estirar Camera",stretch_skew="Estiramento",infinite_zoom="Zoom Infinito",cam_fov="Campo Visual",tab_mods="Mods",tab_blacklist="Blacklist",mod_title="Mods Personagem",mod_korblox="Korblox",mod_headless="Headless",mod_giant="Giant Mode",mod_giant_size="Tamanho Gigante",bl_title="Lista Negra de Skills",bl_enable="Ativar Filtro Blacklist",bl_reset="Resetar Blacklist",bl_reset_done="Blacklist resetada",bl_all_melee="Todos Melee",bl_melee_z="Melee Z",bl_melee_x="Melee X",bl_melee_c="Melee C",bl_all_fruit="Todos Fruit",bl_fruit_m1="Fruit M1",bl_fruit_z="Fruit Z",bl_fruit_x="Fruit X",bl_fruit_c="Fruit C",bl_fruit_v="Fruit V",bl_fruit_f="Fruit F",bl_all_sword="Todos Sword",bl_sword_z="Sword Z",bl_sword_x="Sword X",bl_all_gun="Todos Gun",bl_gun_z="Gun Z",bl_gun_x="Gun X",bl_gun_m1="Gun M1",fps_preset="FPS Preset 240",ultra_potato="Ultra Potato",low_tex="Low Textures",no_shadows="No Shadows",fullbright="Fullbright",no_fog="No Fog",gray_sky="Gray Sky",hide_v4="Hide V4 FX",anti_lag="Anti Lag Pro",ff_title="Otimizadores FastFlag",ff_more="Mais Opcoes",tab_esp="ESP",tab_hitbox="Hitbox",tab_info="Info",tab_ui="UI",tab_settings="Config",skill_aimbot="Skill Aimbot",skill_aimbot_toggle="Skill Aimbot",skill_camlock="Skill CamLock",perm_camlock="Permanent CamLock",skill_aimbot_mode="Skill Aimbot Mode",skill_aimbot_dist="Skill Aimbot Distance",target_switch="Target Switch Delay (cs)",target_lock="Target Lock",silent_aim="Silent Aim",player_silent="Player Silent Aim",npc_silent="NPC Silent Aim",show_fov="Show FOV Circle",aim_mode="Aim Mode",priority="Priority",fov_mode="FOV Mode",fov_radius="FOV Radius",max_range="Max Range",speed="Speed",speed_boost="Speed Boost",speed_mult="Speed Multiplier",glitch_sg="Glitch (Soul Guitar)",glitch_enabled="Glitch Enabled",glide_speed="Glide Speed",glide_time="Glide Time (cs)",dash_length="Dash Length",dash_enabled="Enable Dash Length",dash_dist="Dash Distance",jump="Jump",jump_force="Jump Force (G)",mobile_jump_btn="Mobile Jump Button",extra="Extra",fastskill="FastSkill",infinite_soru="Soru Infinito",anti_stun="Anti Stun",skill_soru="Skill Soru",soru_weapon="Arma Soru",soru_skill="Skill Soru",soru_delay="Delay Soru",soru_assist="Soru Assist",enable_soru="Enable Soru Assist",show_soru_fov="Show Soru FOV",sticky_target="Sticky Target",wall_check="Wall Check",movement_pred="Movement Prediction",targeting="Targeting",soru_aim_mode="Soru Aim Mode",soru_target_part="Soru Target Part",soru_priority="Soru Priority",range_fov="Range & FOV",soru_range="Soru Range",soru_fov_type="Soru FOV Type",soru_fov_radius="Soru FOV Radius",advanced="Advanced",soru_pred_pct="Soru Prediction %",sanguine="Sanguine Z",dtalon="DTalon Z",diamond="Diamond Z",eclaw="EClaw X",big_skin="Big Skin Bug",power="Power",duration="Duracao",min_charge="Min Charge",big_skin_toggle="Big Skin",fly_enabled="Enabled",fly_speed="Fly Speed",controls="Controles",fly_info="W/A/S/D para mover\nH alterna fly\nFly usa a direcao da camera\n\nF2 minimiza/mostra o hub",gun_click="Gun Click SL",enable_gun="Enable Gun Click SL",m1_ext="M1 Extender",enable_m1="Enable M1 Extender",ext_range="Extender Range",fa_title="Fast Attack",fa_enable="Fast Attack",fa_delay="Vel. Ataque",info="Info",gun_info="Gun Click SL:\nEscolhe o player mais proximo\ndentro da distancia e redireciona\no tiro pra ele.\n\nM1 Extender:\nEstende o alcance do M1\npara atingir alvos a distancia.",esp_settings="ESP Settings",enable_esp="Enable ESP",show_box="Show Box",show_name="Show Name",show_dist="Show Distance",show_health="Show Health",show_all="Show All Players",line_origin="Line Origin",esp_appearance="ESP Appearance",show_tracers="Show Tracers (Lines)",box_color="Box Color",text_color="Text Color",line_color="Line Color",config_slots="Config Slots",save_name="Salvar com este nome",load_selected="Carregar selecionado",overwrite="Sobrescrever selecionado",delete="Deletar selecionado",refresh_list="Atualizar lista",auto_save="Auto Save",auto_save_toggle="Auto Save (a cada mudanca)",interval="Intervalo (segundos)",auto_load="Auto Load",auto_load_toggle="Auto Load ao iniciar",save_autoload="Salvar escolha de auto-load",unload="Unload",unload_dw="Unload HardyWare",close_script="Close Script (unload total)",language="Idioma",language_desc="Escolha o idioma do hub:",notif_title="HardyWare",enabled="ativado",disabled="desativado",loaded="Hub carregado",nenhum="(nenhum)",placeholder_config="nome do config",hb_expander="Expansor de Hitbox",hb_toggle="Expansor de Hitbox",hb_size="Tamanho da Caixa",hb_npc="Expandir NPCs",hb_show="Mostrar Hitboxes",anti_combo="Anti Combo",portal_x_toggle="Portal X Fuga",skull_x_toggle="Skull Guitar X Fuga",soru_escape_toggle="Soru Fuga",ui_scale="Escala do Painel (UI Scale)"},["en"]={tab_pvp="PVP",tab_soru="Soru",tab_glitch="Glitch V2",tab_fly="Fly",tab_gun="Gun",tab_fps="Fps",tab_camera="Camera",cam_title="Camera Glitches",stretch_cam="Stretch Camera",stretch_skew="Stretch Skew",infinite_zoom="Infinite zoom",cam_fov="Cam FOV",tab_mods="Mods",tab_blacklist="Blacklist",mod_title="Character Mods",mod_korblox="Korblox",mod_headless="Headless",mod_giant="Giant Mode",mod_giant_size="Giant Size",bl_title="Skill Blacklist",bl_enable="Enable Blacklist Filter",bl_reset="Reset Blacklist",bl_reset_done="Blacklist reset",bl_all_melee="All Melee",bl_melee_z="Melee Z",bl_melee_x="Melee X",bl_melee_c="Melee C",bl_all_fruit="All Fruit",bl_fruit_m1="Fruit M1",bl_fruit_z="Fruit Z",bl_fruit_x="Fruit X",bl_fruit_c="Fruit C",bl_fruit_v="Fruit V",bl_fruit_f="Fruit F",bl_all_sword="All Sword",bl_sword_z="Sword Z",bl_sword_x="Sword X",bl_all_gun="All Gun",bl_gun_z="Gun Z",bl_gun_x="Gun X",bl_gun_m1="Gun M1",fps_preset="FPS Preset 240",ultra_potato="Ultra Potato",low_tex="Low Textures",no_shadows="No Shadows",fullbright="Fullbright",no_fog="No Fog",gray_sky="Gray Sky",hide_v4="Hide V4 FX",anti_lag="Anti Lag Pro",ff_title="FastFlag Optimizers",ff_more="More Options",tab_esp="ESP",tab_hitbox="Hitbox",tab_info="Info",tab_ui="UI",tab_settings="Settings",skill_aimbot="Skill Aimbot",skill_aimbot_toggle="Skill Aimbot",skill_camlock="Skill CamLock",perm_camlock="Permanent CamLock",skill_aimbot_mode="Skill Aimbot Mode",skill_aimbot_dist="Skill Aimbot Distance",target_switch="Target Switch Delay (cs)",target_lock="Target Lock",silent_aim="Silent Aim",player_silent="Player Silent Aim",npc_silent="NPC Silent Aim",show_fov="Show FOV Circle",aim_mode="Aim Mode",priority="Priority",fov_mode="FOV Mode",fov_radius="FOV Radius",max_range="Max Range",speed="Speed",speed_boost="Speed Boost",speed_mult="Speed Multiplier",glitch_sg="Glitch (Soul Guitar)",glitch_enabled="Glitch Enabled",glide_speed="Glide Speed",glide_time="Glide Time (cs)",dash_length="Dash Length",dash_enabled="Enable Dash Length",dash_dist="Dash Distance",jump="Jump",jump_force="Jump Force (G)",mobile_jump_btn="Mobile Jump Button",extra="Extra",fastskill="FastSkill",infinite_soru="Infinite Soru",anti_stun="Anti Stun",skill_soru="Skill Soru",soru_weapon="Soru Weapon",soru_skill="Soru Skill",soru_delay="Soru Delay",soru_assist="Soru Assist",enable_soru="Enable Soru Assist",show_soru_fov="Show Soru FOV",sticky_target="Sticky Target",wall_check="Wall Check",movement_pred="Movement Prediction",targeting="Targeting",soru_aim_mode="Soru Aim Mode",soru_target_part="Soru Target Part",soru_priority="Soru Priority",range_fov="Range & FOV",soru_range="Soru Range",soru_fov_type="Soru FOV Type",soru_fov_radius="Soru FOV Radius",advanced="Advanced",soru_pred_pct="Soru Prediction %",sanguine="Sanguine Z",dtalon="DTalon Z",diamond="Diamond Z",eclaw="EClaw X",big_skin="Big Skin Bug",power="Power",duration="Duration",min_charge="Min Charge",big_skin_toggle="Big Skin",fly_enabled="Enabled",fly_speed="Fly Speed",controls="Controls",fly_info="W/A/S/D to move\nH toggles fly\nFly uses camera direction\n\nF2 minimizes/shows the hub",gun_click="Gun Click SL",enable_gun="Enable Gun Click SL",m1_ext="M1 Extender",enable_m1="Enable M1 Extender",ext_range="Extender Range",fa_title="Fast Attack",fa_enable="Fast Attack",fa_delay="Fast Delay",info="Info",gun_info="Gun Click SL:\nSelects the closest player\nwithin range and redirects\nthe shot to them.\n\nM1 Extender:\nExtends M1 range\nto hit targets at distance.",esp_settings="ESP Settings",enable_esp="Enable ESP",show_box="Show Box",show_name="Show Name",show_dist="Show Distance",show_health="Show Health",show_all="Show All Players",line_origin="Line Origin",esp_appearance="ESP Appearance",show_tracers="Show Tracers (Lines)",box_color="Box Color",text_color="Text Color",line_color="Line Color",config_slots="Config Slots",save_name="Save with this name",load_selected="Load selected",overwrite="Overwrite selected",delete="Delete selected",refresh_list="Refresh list",auto_save="Auto Save",auto_save_toggle="Auto Save (on every change)",interval="Interval (seconds)",auto_load="Auto Load",auto_load_toggle="Auto Load on start",save_autoload="Save auto-load choice",unload="Unload",unload_dw="Unload HardyWare",close_script="Close Script (full unload)",language="Language",language_desc="Choose the hub language:",notif_title="HardyWare",enabled="enabled",disabled="disabled",loaded="Hub loaded",nenhum="(none)",placeholder_config="config name",hb_expander="Hitbox Expander",hb_toggle="Hitbox Expander",hb_size="Hitbox Size",hb_npc="Expand NPCs",hb_show="Show Hitboxes",anti_combo="Anti Combo",portal_x_toggle="Portal X Escape",skull_x_toggle="Skull Guitar X Escape",soru_escape_toggle="Soru Escape",ui_scale="Panel Scale (UI Scale)"},["es"]={tab_pvp="PVP",tab_soru="Soru",tab_glitch="Glitch V2",tab_fly="Fly",tab_gun="Gun",tab_fps="Fps",tab_camera="Camara",cam_title="Glitches de Camara",stretch_cam="Estirar Camara",stretch_skew="Estiramiento",infinite_zoom="Zoom Infinito",cam_fov="Campo Visual",tab_mods="Mods",tab_blacklist="Blacklist",mod_title="Mods Personaje",mod_korblox="Korblox",mod_headless="Headless",mod_giant="Modo Gigante",mod_giant_size="Tamano Gigante",bl_title="Lista Negra de Skills",bl_enable="Activar Filtro Blacklist",bl_reset="Limpiar Lista",bl_reset_done="Lista limpiada",bl_all_melee="Todos Melee",bl_melee_z="Melee Z",bl_melee_x="Melee X",bl_melee_c="Melee C",bl_all_fruit="Todos Fruit",bl_fruit_m1="Fruit M1",bl_fruit_z="Fruit Z",bl_fruit_x="Fruit X",bl_fruit_c="Fruit C",bl_fruit_v="Fruit V",bl_fruit_f="Fruit F",bl_all_sword="Todos Sword",bl_sword_z="Sword Z",bl_sword_x="Sword X",bl_all_gun="Todos Gun",bl_gun_z="Gun Z",bl_gun_x="Gun X",bl_gun_m1="Gun M1",fps_preset="FPS Preset 240",ultra_potato="Ultra Potato",low_tex="Low Textures",no_shadows="No Shadows",fullbright="Fullbright",no_fog="No Fog",gray_sky="Gray Sky",hide_v4="Hide V4 FX",anti_lag="Anti Lag Pro",ff_title="Optimizadores FastFlag",ff_more="Mas Opciones",tab_esp="ESP",tab_hitbox="Hitbox",tab_info="Info",tab_ui="UI",tab_settings="Config",skill_aimbot="Skill Aimbot",skill_aimbot_toggle="Skill Aimbot",skill_camlock="Skill CamLock",perm_camlock="CamLock Permanente",skill_aimbot_mode="Modo Skill Aimbot",skill_aimbot_dist="Distancia Skill Aimbot",target_switch="Retraso cambio objetivo (cs)",target_lock="Bloqueo de objetivo",silent_aim="Silent Aim",player_silent="Silent Aim Jugadores",npc_silent="Silent Aim NPCs",show_fov="Mostrar circulo FOV",aim_mode="Modo de apuntado",priority="Prioridad",fov_mode="Modo FOV",fov_radius="Radio FOV",max_range="Alcance maximo",speed="Velocidad",speed_boost="Aumento de velocidad",speed_mult="Multiplicador",glitch_sg="Glitch (Soul Guitar)",glitch_enabled="Glitch activado",glide_speed="Velocidad de planeo",glide_time="Tiempo de planeo (cs)",dash_length="Longitud del Dash",dash_enabled="Activar Longitud del Dash",dash_dist="Distancia del Dash",jump="Salto",jump_force="Fuerza de salto (G)",mobile_jump_btn="Boton de salto movil",extra="Extra",fastskill="Habilidad rapida",infinite_soru="Soru Infinito",anti_stun="Anti Stun",skill_soru="Skill Soru",soru_weapon="Arma Soru",soru_skill="Skill Soru",soru_delay="Delay Soru",soru_assist="Asistencia Soru",enable_soru="Activar asistencia Soru",show_soru_fov="Mostrar FOV Soru",sticky_target="Objetivo pegajoso",wall_check="Verificar pared",movement_pred="Prediccion de movimiento",targeting="Objetivos",soru_aim_mode="Modo apuntado Soru",soru_target_part="Parte objetivo Soru",soru_priority="Prioridad Soru",range_fov="Alcance y FOV",soru_range="Alcance Soru",soru_fov_type="Tipo FOV Soru",soru_fov_radius="Radio FOV Soru",advanced="Avanzado",soru_pred_pct="Prediccion Soru %",sanguine="Sanguine Z",dtalon="DTalon Z",diamond="Diamond Z",eclaw="EClaw X",big_skin="Bug piel grande",power="Poder",duration="Duracion",min_charge="Carga minima",big_skin_toggle="Piel grande",fly_enabled="Activado",fly_speed="Velocidad de vuelo",controls="Controles",fly_info="W/A/S/D para mover\nH alterna vuelo\nVuelo usa direccion camara\n\nF2 minimiza/muestra el hub",gun_click="Gun Click SL",enable_gun="Activar Gun Click SL",m1_ext="Extensor M1",enable_m1="Activar Extensor M1",ext_range="Rango del extensor",fa_title="Ataque Rapido",fa_enable="Ataque Rapido",fa_delay="Vel. Golpe",info="Info",gun_info="Gun Click SL:\nSelecciona el jugador mas cercano\ny redirige el disparo.\n\nM1 Extender:\nExtiende el rango del M1\npara alcanzar objetivos a distancia.",esp_settings="Ajustes ESP",enable_esp="Activar ESP",show_box="Mostrar caja",show_name="Mostrar nombre",show_dist="Mostrar distancia",show_health="Mostrar salud",show_all="Mostrar todos",line_origin="Origen de linea",esp_appearance="Apariencia ESP",show_tracers="Mostrar trazadores",box_color="Color de caja",text_color="Color de texto",line_color="Color de linea",config_slots="Slots de config",save_name="Guardar con este nombre",load_selected="Cargar seleccionado",overwrite="Sobrescribir seleccionado",delete="Eliminar seleccionado",refresh_list="Actualizar lista",auto_save="Guardado automatico",auto_save_toggle="Auto guardar (cada cambio)",interval="Intervalo (segundos)",auto_load="Carga automatica",auto_load_toggle="Auto cargar al iniciar",save_autoload="Guardar opcion auto-load",unload="Descargar",unload_dw="Descargar HardyWare",close_script="Cerrar Script (descarga total)",language="Idioma",language_desc="Elige el idioma del hub:",notif_title="HardyWare",enabled="activado",disabled="desactivado",loaded="Hub cargado",nenhum="(ninguno)",placeholder_config="nombre del config",hb_expander="Expansor de Hitbox",hb_toggle="Expansor de Hitbox",hb_size="Tamaño de la caja",hb_npc="Expandir NPCs",hb_show="Mostrar Hitboxes",anti_combo="Anti Combo",portal_x_toggle="Portal X Fuga",skull_x_toggle="Skull Guitar X Fuga",soru_escape_toggle="Soru Fuga",ui_scale="Escala del Panel (UI Scale)"},["fr"]={tab_pvp="PVP",tab_soru="Soru",tab_glitch="Glitch V2",tab_fly="Fly",tab_gun="Gun",tab_fps="Fps",tab_camera="Camera",cam_title="Glitches Camera",stretch_cam="Etirer Camera",stretch_skew="Etirement",infinite_zoom="Zoom Infini",cam_fov="Champ Visuel",tab_mods="Mods",tab_blacklist="Blacklist",mod_title="Mods Personnage",mod_korblox="Korblox",mod_headless="Headless",mod_giant="Mode Geant",mod_giant_size="Taille Geante",bl_title="Liste Noire de Skills",bl_enable="Activer Filtre Blacklist",bl_reset="Reinitialiser",bl_reset_done="Liste reinitialisee",bl_all_melee="Tous Melee",bl_melee_z="Melee Z",bl_melee_x="Melee X",bl_melee_c="Melee C",bl_all_fruit="Tous Fruit",bl_fruit_m1="Fruit M1",bl_fruit_z="Fruit Z",bl_fruit_x="Fruit X",bl_fruit_c="Fruit C",bl_fruit_v="Fruit V",bl_fruit_f="Fruit F",bl_all_sword="Tous Sword",bl_sword_z="Sword Z",bl_sword_x="Sword X",bl_all_gun="Tous Gun",bl_gun_z="Gun Z",bl_gun_x="Gun X",bl_gun_m1="Gun M1",fps_preset="FPS Preset 240",ultra_potato="Ultra Potato",low_tex="Low Textures",no_shadows="No Shadows",fullbright="Fullbright",no_fog="No Fog",gray_sky="Gray Sky",hide_v4="Hide V4 FX",anti_lag="Anti Lag Pro",ff_title="Optimiseurs FastFlag",ff_more="Plus d Options",tab_esp="ESP",tab_hitbox="Hitbox",tab_info="Info",tab_ui="UI",tab_settings="Config",skill_aimbot="Skill Aimbot",skill_aimbot_toggle="Skill Aimbot",skill_camlock="Skill CamLock",perm_camlock="CamLock Permanent",skill_aimbot_mode="Mode Skill Aimbot",skill_aimbot_dist="Distance Skill Aimbot",target_switch="Delai change cible (cs)",target_lock="Verrouillage cible",silent_aim="Silent Aim",player_silent="Silent Aim Joueurs",npc_silent="Silent Aim PNJ",show_fov="Afficher cercle FOV",aim_mode="Mode visee",priority="Priorite",fov_mode="Mode FOV",fov_radius="Rayon FOV",max_range="Portee max",speed="Vitesse",speed_boost="Boost de vitesse",speed_mult="Multiplicateur",glitch_sg="Glitch (Soul Guitar)",glitch_enabled="Glitch active",glide_speed="Vitesse de glisse",glide_time="Temps de glisse (cs)",dash_length="Longueur du Dash",dash_enabled="Activer Longueur du Dash",dash_dist="Distance du Dash",jump="Saut",jump_force="Force de saut (G)",mobile_jump_btn="Bouton saut mobile",extra="Extra",fastskill="Competence rapide",infinite_soru="Soru Infini",anti_stun="Anti Stun",skill_soru="Skill Soru",soru_weapon="Arme Soru",soru_skill="Skill Soru",soru_delay="Delai Soru",soru_assist="Assistance Soru",enable_soru="Activer assistance Soru",show_soru_fov="Afficher FOV Soru",sticky_target="Cible collante",wall_check="Verif mur",movement_pred="Prediction mouvement",targeting="Ciblage",soru_aim_mode="Mode visee Soru",soru_target_part="Partie cible Soru",soru_priority="Priorite Soru",range_fov="Portee et FOV",soru_range="Portee Soru",soru_fov_type="Type FOV Soru",soru_fov_radius="Rayon FOV Soru",advanced="Avance",soru_pred_pct="Prediction Soru %",sanguine="Sanguine Z",dtalon="DTalon Z",diamond="Diamond Z",eclaw="EClaw X",big_skin="Bug grosse peau",power="Puissance",duration="Duree",min_charge="Charge min",big_skin_toggle="Grosse peau",fly_enabled="Active",fly_speed="Vitesse de vol",controls="Controles",fly_info="W/A/S/D pour bouger\nH bascule le vol\nLe vol suit la camera\n\nF2 minimise/affiche le hub",gun_click="Gun Click SL",enable_gun="Activer Gun Click SL",m1_ext="Extenseur M1",enable_m1="Activer Extenseur M1",ext_range="Portee extenseur",fa_title="Attaque Rapide",fa_enable="Attaque Rapide",fa_delay="Vit. Attaque",info="Info",gun_info="Gun Click SL:\nSelectionne le joueur le plus proche\net redirige le tir.\n\nM1 Extender:\nEtend la portee du M1\npour toucher les cibles a distance.",esp_settings="Reglages ESP",enable_esp="Activer ESP",show_box="Afficher boite",show_name="Afficher nom",show_dist="Afficher distance",show_health="Afficher sante",show_all="Afficher tous",line_origin="Origine ligne",esp_appearance="Apparence ESP",show_tracers="Afficher traces",box_color="Couleur boite",text_color="Couleur texte",line_color="Couleur ligne",config_slots="Slots config",save_name="Sauvegarder avec ce nom",load_selected="Charger selectionne",overwrite="Ecraser selectionne",delete="Supprimer selectionne",refresh_list="Rafraichir liste",auto_save="Sauvegarde auto",auto_save_toggle="Auto sauvegarde (chaque changement)",interval="Intervalle (secondes)",auto_load="Chargement auto",auto_load_toggle="Auto charger au demarrage",save_autoload="Sauvegarder choix auto-load",unload="Decharger",unload_dw="Decharger HardyWare",close_script="Fermer Script (dechargement total)",language="Langue",language_desc="Choisissez la langue du hub:",notif_title="HardyWare",enabled="active",disabled="desactive",loaded="Hub charge",nenhum="(aucun)",placeholder_config="nom du config",hb_expander="Expansor de Hitbox",hb_toggle="Expansor de Hitbox",hb_size="Taille de la boîte",hb_npc="Étendre les PNJ",hb_show="Afficher les Hitboxes",anti_combo="Anti Combo",portal_x_toggle="Portal X Evasion",skull_x_toggle="Skull Guitar X Evasion",soru_escape_toggle="Soru Evasion",ui_scale="Echelle du Panneau (UI Scale)"},}
local LanguageNames={["pt"]="Portugues (BR)",["en"]="English",["es"]="Espanol",["fr"]="Francais",}
local CurrentLang="pt"
pcall(function()if type(readfile)=="function" and type(isfile)=="function" then if isfile("HardyWareLang.txt")then local v=readfile("HardyWareLang.txt")if Languages[v]then CurrentLang=v end end end end)
local function t(key)local lang=Languages[CurrentLang]or Languages["pt"]return lang[key]or Languages["pt"][key]or key end
local TransRegistry={}
local function refreshAllTranslations()for _,entry in ipairs(TransRegistry)do if entry.obj and entry.obj.Parent then pcall(function()entry.obj[entry.prop]=t(entry.key)..entry.suffix end)end end if _G.__HardyWareTabTrans then for name,lbl in pairs(_G.__HardyWareTabTrans)do if lbl and lbl.Parent then pcall(function()lbl.Text=t(name)end)end end end end
local function saveLang(code)pcall(function()if type(writefile)=="function" then writefile("HardyWareLang.txt",code)end end)end
local State={GlideEnabled=false,GlideSpeed=350,GlideTime=0.2,JumpForce=300,LastShootTime=0,flyActive=false,flySpeed=400,speedBoost=false,speedValue=2,DashLengthEnabled=false,DashLengthValue=1,HitboxExpander=false,HitboxSize=10,HitboxNPCs=false,HitboxVisual=false,AntiCombo=false,AntiComboSkull=false,AntiComboSoru=false,InfiniteSoruEnabled=false,AntiStunEnabled=false,SkillSoruEnabled=false,SoruWeapon="Fruit",SoruSkill="Z",SoruDelay=0.30}
local function toggleInfiniteSoru(enabled)State.InfiniteSoruEnabled=enabled local char=player.Character if char then pcall(function()char:SetAttribute("FlashstepCooldown",enabled and 0.95 or 0)end)end end
RunService.Heartbeat:Connect(function()if State.InfiniteSoruEnabled then local char=player.Character if char then pcall(function()if char:GetAttribute("FlashstepCooldown")~=0.95 then char:SetAttribute("FlashstepCooldown",0.95)end end)end end end)
local function toggleAntiStun(enabled)State.AntiStunEnabled=enabled if not enabled then local char=player.Character if char then for _,v in ipairs(char:GetDescendants())do if v:IsA("BasePart")and v.Name~="HumanoidRootPart" then v.CanCollide=true end end end end end
local lastAntiStun=0
RunService.Heartbeat:Connect(function()if State.AntiStunEnabled then local now=os.clock() if now-lastAntiStun<0.08 then return end lastAntiStun=now local char=player.Character if char then pcall(function()if char:GetAttribute("Stun")then char:SetAttribute("Stun",0)end local root=char:FindFirstChild("HumanoidRootPart")if root then for _,child in ipairs(root:GetChildren())do if(child:IsA("BodyVelocity")or child:IsA("BodyPosition")or child:IsA("BodyGyro"))and child.Name~="RootVelocity"and child.Name~="Keep"and child.Name~="SkyFly"and not child.Name:match("^Spooky_")then child:Destroy()end end end end)end end end)
local function pressSoruKey(kc)
local vim=game:GetService("VirtualInputManager")
vim:SendKeyEvent(true,kc,false,game)
task.wait(0.05)
vim:SendKeyEvent(false,kc,false,game)
end
local skillSoruDebounce=0
local function executeSkillSoru()if not State.SkillSoruEnabled then return end local now=tick()if now-skillSoruDebounce<0.35 then return end skillSoruDebounce=now task.spawn(function()local ok,err=pcall(function()local delayVal=tonumber(State.SoruDelay)or 0.30 if delayVal>0 then task.wait(delayVal)end if not State.SkillSoruEnabled then return end local slotMap={Melee=1,Fruit=2,Sword=3,Gun=4}local slotNum=slotMap[State.SoruWeapon or"Fruit"]or 2 local SLOT_KEYS={[1]=Enum.KeyCode.One,[2]=Enum.KeyCode.Two,[3]=Enum.KeyCode.Three,[4]=Enum.KeyCode.Four}local slotKey=SLOT_KEYS[slotNum]if slotKey then pressSoruKey(slotKey) end task.wait(0.12)local keyName=State.SoruSkill or"Z"if Enum.KeyCode[keyName]then pressSoruKey(Enum.KeyCode[keyName]) end end)if not ok then warn("[HardyWare SkillSoru] "..tostring(err))end end)end
local function hookSkillSoru(hum)if not hum then return end hum.AnimationPlayed:Connect(function(track)pcall(function()if not State.SkillSoruEnabled then return end local animId=(track.Animation and track.Animation.AnimationId)or""local trackName=track.Name or""local isFlashstep=animId:find("17555632156")or animId:find("18461649274")or animId:find("616006778")or animId:find("616010882")or animId:find("5403485593")or animId:find("5403491911")or animId:find("313762630")or animId:find("313762631")or trackName:lower():find("flash")or trackName:lower():find("soru")if isFlashstep then executeSkillSoru()end end)end)end
if player.Character then local hum=player.Character:FindFirstChildOfClass("Humanoid")if hum then pcall(hookSkillSoru,hum)end end
player.CharacterAdded:Connect(function(c)task.spawn(function()local ok,hum=pcall(function()return c:WaitForChild("Humanoid",5)end)if ok and hum then pcall(hookSkillSoru,hum)end end)end)
local FlyVel=nil
local GlitchV2=(function()local S={sanguineEnabled=false,sanguinePower=400,sanguineDuration=0.9,sanguineCharge=0.1,dtalonEnabled=false,dtalonPower=400,dtalonDuration=0.9,dtalonCharge=1.0,diamondEnabled=false,diamondPower=250,diamondDuration=0.3,diamondCharge=1.0,eclawEnabled=false,eclawPower=400,eclawDuration=1.7,eclawCharge=0.0,bigSkinBugEnabled=false,}
local sanguineCharging,sanguineChargeStart=false,0
local dtalonCharging,dtalonChargeStart=false,0
local diamondCharging,diamondChargeStart=false,0
local function getDmgLabel()local pg=player:FindFirstChild("PlayerGui")local main=pg and pg:FindFirstChild("Main")local dmg=main and main:FindFirstChild("DmgCounter")return dmg and dmg:FindFirstChild("Text")end
local function SanguineBoost()local char=player.Character local hrp=char and char:FindFirstChild("HumanoidRootPart")local hum=char and char:FindFirstChild("Humanoid")if not hrp or not hum then return end local dir=camera.CFrame.LookVector hum.PlatformStand=true local att=Instance.new("Attachment",hrp)local lv=Instance.new("LinearVelocity",hrp)lv.MaxForce=9999999 lv.VelocityConstraintMode=Enum.VelocityConstraintMode.Vector lv.VectorVelocity=dir*S.sanguinePower lv.Attachment0=att local boostActive=true local boostEndTime=tick()+S.sanguineDuration local dmgConn local function stopPropulsion()if not boostActive then return end boostActive=false if lv then lv:Destroy()end if att then att:Destroy()end if hum then hum.PlatformStand=false end if dmgConn then dmgConn:Disconnect()end end local dmgLabel=getDmgLabel()local startText=dmgLabel and dmgLabel.Text or""if dmgLabel then dmgConn=dmgLabel:GetPropertyChangedSignal("Text"):Connect(function()local currentText=dmgLabel.Text if currentText~=startText and currentText~=""and currentText~="0"then stopPropulsion()end end)end while boostActive and tick()<boostEndTime do task.wait()end stopPropulsion()end
RunService.Heartbeat:Connect(function()if not S.sanguineEnabled then return end local char=player.Character local hum=char and char:FindFirstChild("Humanoid")if not hum then return end local isGC=false for _,a in pairs(hum:GetPlayingAnimationTracks())do if a.Animation and(a.Animation.AnimationId:find("14418367908")or a.Name=="GhoulZCharge")then isGC=true break end end if isGC then if not sanguineCharging then sanguineCharging=true sanguineChargeStart=tick()end else if sanguineCharging then if(tick()-sanguineChargeStart)>=S.sanguineCharge then task.spawn(SanguineBoost)end sanguineCharging=false sanguineChargeStart=0 end end end)
local function DTalonBoost()local char=player.Character local hrp=char and char:FindFirstChild("HumanoidRootPart")local hum=char and char:FindFirstChild("Humanoid")if not hrp or not hum then return end local dir=camera.CFrame.LookVector hum.PlatformStand=true local att=Instance.new("Attachment",hrp)local lv=Instance.new("LinearVelocity",hrp)lv.MaxForce=9999999 lv.VelocityConstraintMode=Enum.VelocityConstraintMode.Vector lv.VectorVelocity=dir*S.dtalonPower lv.Attachment0=att local boostActive=true local boostEndTime=tick()+S.dtalonDuration local dmgConn local function stopPropulsion()if not boostActive then return end boostActive=false if lv then lv:Destroy()end if att then att:Destroy()end if hum then hum.PlatformStand=false end if dmgConn then dmgConn:Disconnect()end end local dmgLabel=getDmgLabel()local startText=dmgLabel and dmgLabel.Text or""if dmgLabel then dmgConn=dmgLabel:GetPropertyChangedSignal("Text"):Connect(function()local currentText=dmgLabel.Text if currentText~=startText and currentText~=""and currentText~="0"then stopPropulsion()end end)end while boostActive and tick()<boostEndTime do task.wait()end stopPropulsion()end
RunService.Heartbeat:Connect(function()if not S.dtalonEnabled then return end local char=player.Character local hum=char and char:FindFirstChild("Humanoid")if not hum then return end local isC=false for _,a in pairs(hum:GetPlayingAnimationTracks())do if a.Animation and(a.Animation.AnimationId:find("18839089313")or a.Name=="DTalon_ZCharge")then isC=true break end end if isC then if not dtalonCharging then dtalonCharging=true dtalonChargeStart=tick()end else if dtalonCharging then if(tick()-dtalonChargeStart)>=S.dtalonCharge then task.spawn(DTalonBoost)end dtalonCharging=false dtalonChargeStart=0 end end end)
local function DiamondBoost()local char=player.Character local hrp=char and char:FindFirstChild("HumanoidRootPart")local hum=char and char:FindFirstChild("Humanoid")if not hrp or not hum then return end local dir=camera.CFrame.LookVector hum.PlatformStand=true local att=Instance.new("Attachment",hrp)local lv=Instance.new("LinearVelocity",hrp)lv.MaxForce=9999999 lv.VelocityConstraintMode=Enum.VelocityConstraintMode.Vector lv.VectorVelocity=dir*S.diamondPower lv.Attachment0=att local boostActive=true local boostEndTime=tick()+S.diamondDuration local dmgConn local function stopPropulsion()if not boostActive then return end boostActive=false if lv then lv:Destroy()end if att then att:Destroy()end if hum then hum.PlatformStand=false end if dmgConn then dmgConn:Disconnect()end end local dmgLabel=getDmgLabel()local startText=dmgLabel and dmgLabel.Text or""if dmgLabel then dmgConn=dmgLabel:GetPropertyChangedSignal("Text"):Connect(function()local currentText=dmgLabel.Text if currentText~=startText and currentText~=""and currentText~="0"then stopPropulsion()end end)end while boostActive and tick()<boostEndTime do task.wait()end stopPropulsion()end
RunService.Heartbeat:Connect(function()if not S.diamondEnabled then return end local char=player.Character local hum=char and char:FindFirstChild("Humanoid")if not hum then return end local isC=false for _,a in pairs(hum:GetPlayingAnimationTracks())do if a.Animation and a.Animation.AnimationId:find("14414815375")then isC=true break end end if isC then if not diamondCharging then diamondCharging=true diamondChargeStart=tick()end else if diamondCharging then if(tick()-diamondChargeStart)>=S.diamondCharge then task.spawn(DiamondBoost)end diamondCharging=false diamondChargeStart=0 end end end)
local function EClawBoost()local char=player.Character local hrp=char and char:FindFirstChild("HumanoidRootPart")local hum=char and char:FindFirstChildOfClass("Humanoid")if not hrp or not hum then return end local mouse=player:GetMouse()local dir=(mouse.Hit.p-hrp.Position).Unit hum.PlatformStand=true local att=Instance.new("Attachment",hrp)local lv=Instance.new("LinearVelocity",hrp)lv.MaxForce=9999999 lv.VelocityConstraintMode=Enum.VelocityConstraintMode.Vector lv.VectorVelocity=dir*S.eclawPower lv.Attachment0=att local boostActive=true local boostEndTime=tick()+S.eclawDuration local dmgConn local function stopPropulsion()if not boostActive then return end boostActive=false if lv then lv:Destroy()end if att then att:Destroy()end if hum then hum.PlatformStand=false end if dmgConn then dmgConn:Disconnect()end end local dmgLabel=getDmgLabel()local startText=dmgLabel and dmgLabel.Text or""if dmgLabel then dmgConn=dmgLabel:GetPropertyChangedSignal("Text"):Connect(function()local currentText=dmgLabel.Text if currentText~=startText and currentText~=""and currentText~="0"then stopPropulsion()end end)end while boostActive and tick()<boostEndTime do task.wait()end stopPropulsion()end
local function hookEClaw(hum)hum.AnimationPlayed:Connect(function(track)if not S.eclawEnabled then return end if track.Animation and(track.Animation.AnimationId:find("6875496851")or track.Name=="ElectroClawXImpact")then local chargeStart=tick()track.Stopped:Connect(function()if(tick()-chargeStart)>=S.eclawCharge then task.spawn(EClawBoost)end end)end end)end
if player.Character then local hum=player.Character:FindFirstChildOfClass("Humanoid")if hum then hookEClaw(hum)end end
player.CharacterAdded:Connect(function(c)local hum=c:WaitForChild("Humanoid",5)if hum then hookEClaw(hum)end end)
local M={S=S}return M end)()
local SilentAimModule = (function()
    local module = {}
    local cfg = {
        silentPlayers = false, silentNPCs = false,
        aimMode = "360", targetPriority = "Nearest",
        fovMode = "V1", fovRadius = 100, maxRange = 1000, showFOV = false,
        prediction = true, predictionAmt = 0.12,
        silentPart = "HumanoidRootPart", silentSticky = true, silentStickyTime = 0.55,
        silentTP = false, silentTPDist = 999,
        skillAimbot = false, skillSilent = true, skillCamLock = false, permanentCamLock = false,
        skillAimbotDist = 999, skillAimbotMode = "Both", targetSwitchDelay = 0,
        targetLockActive = false, targetLockRoot = nil, targetLockPlayer = nil,
        soruEnabled = false, soruRange = 300, soruAimMode = "360", soruFOVType = "V1",
        soruFOVRadius = 100, soruPriority = "Nearest", soruShowFOV = false,
        soruPrediction = true, soruPredAmt = 0.12, soruSticky = true,
        soruWallCheck = false, soruTargetPart = "HumanoidRootPart",
        teamCheck = false, safeZoneCheck = true,
        ignoreLowLevel = false, ignoreLowLevelThreshold = 2000,
        lockPart = "HumanoidRootPart", camSmoothness = "Smooth",
        tracerEnabled = false, tracerColorName = "Purple",
        stealth = false,
    }

    local _tracerLine, _tracerColor
    _tracerColor = Color3.fromRGB(175, 115, 255)

    local enemyCache, protectCache = {}, {}
    local ENEMY_TTL, PROTECT_TTL = 0.5, 0.08

    local function getPlayerLevel(pl)
        local ok, lvl = pcall(function()
            local ld = pl:FindFirstChild("leaderstats")
            if ld then
                local lv = ld:FindFirstChild("Level") or ld:FindFirstChild("Lv")
                if lv then return tonumber(lv.Value) or 0 end
            end
            local char = pl.Character
            if char then
                local v = char:GetAttribute("Level") or char:GetAttribute("Lv")
                if v then return tonumber(v) or 0 end
            end
            local v2 = pl:GetAttribute("Level") or pl:GetAttribute("Lv")
            if v2 then return tonumber(v2) or 0 end
            return 0
        end)
        return ok and lvl or 0
    end

    local function cached(key, tbl, ttl, fn)
        local e = tbl[key]
        local now = os.clock()
        if e and (now - e.t) < ttl then return e.v end
        local v = fn()
        tbl[key] = { v = v, t = now }
        return v
    end

    Players.PlayerRemoving:Connect(function(p)
        enemyCache[p] = nil
        protectCache[p] = nil
    end)

    local FOVCircle, SoruFOVCircle
    if Drawing and Drawing.new then
        pcall(function()
            FOVCircle = Drawing.new("Circle")
            FOVCircle.Thickness = 2
            FOVCircle.Color = Color3.fromRGB(255, 0, 0)
            FOVCircle.Filled = false
            FOVCircle.Transparency = 0.8
            FOVCircle.Visible = false
            SoruFOVCircle = Drawing.new("Circle")
            SoruFOVCircle.Thickness = 2
            SoruFOVCircle.Color = Color3.fromRGB(0, 255, 0)
            SoruFOVCircle.Filled = false
            SoruFOVCircle.Transparency = 0.8
            SoruFOVCircle.Visible = false
        end)
    end

    local partCache = setmetatable({}, { __mode = "k" })
    local function getHRP(model)
        if not model then return nil end
        local hum = model:FindFirstChildWhichIsA("Humanoid")
        if hum and hum.RootPart then return hum.RootPart end
        return model:FindFirstChild("HumanoidRootPart")
    end
    local function getMyHRP()
        local c = player.Character
        return c and getHRP(c) or nil
    end
    local function partFor(char, name)
        if not char then return nil end
        local c = partCache[char]
        if c and c.name == name and c.part and c.part.Parent then return c.part end
        local p = name and char:FindFirstChild(name)
        if not (p and p:IsA("BasePart")) then p = getHRP(char) end
        if p then partCache[char] = { name = name, part = p } end
        return p
    end
    local function pickPart(char)
        return partFor(char, cfg.silentPart)
    end

    local function isProtected(tp)
        if not tp then return false end
        return cached(tp, protectCache, PROTECT_TTL, function()
            local char = tp.Character
            if not char then return true end
            if char:FindFirstChildWhichIsA("ForceField") then return true end
            if cfg.safeZoneCheck then
                if char:GetAttribute("SafeZone") == true then return true end
                if char:GetAttribute("InSafeZone") == true then return true end
                if char:GetAttribute("InSafeArea") == true then return true end
                if char:GetAttribute("SafeArea") == true then return true end
                if tp:GetAttribute("SafeZone") == true then return true end
                if tp:GetAttribute("InSafeZone") == true then return true end
                if tp:GetAttribute("InSafeArea") == true then return true end
                if tp:GetAttribute("SafeArea") == true then return true end
            end
            if char:GetAttribute("PvpDisabled") == true then return true end
            if char:GetAttribute("CombatProtected") == true then return true end
            if char:GetAttribute("PVP") == false then return true end
            if tp:GetAttribute("PvpDisabled") == true then return true end
            if tp:GetAttribute("PVP") == false then return true end
            return false
        end)
    end

    local function isEnemy(tp)
        if not tp or tp == player then return false end
        return cached(tp, enemyCache, ENEMY_TTL, function()
            if isProtected(tp) then return false end
            local myT, tT = player.Team, tp.Team
            if myT and tT then
                local mn, tn = myT.Name, tT.Name
                if mn == "Pirates" and tn == "Marines" then return true end
                if mn == "Marines" and tn == "Pirates" then return true end
                if mn == "Pirates" and tn == "Pirates" then return true end
                if mn == "Marines" and tn == "Marines" then return false end
                if cfg.teamCheck and myT == tT then return false end
            end
            return true
        end)
    end

    local statsNet = Stats:FindFirstChild("Network")
    local statsItems = statsNet and statsNet:FindFirstChild("ServerStatsItem")
    local pingItem = statsItems and statsItems:FindFirstChild("Data Ping")
    local pingGetter = pingItem and pingItem.GetValue
    local pingSpoofOld, pingSpoofNew = nil, nil
    local pingSpoofMeta = false
    local lastPingSample, smoothedPing = 0, 0
    local function resolvePingItem()
        if pingItem and pingItem.Parent then return true end
        local net = Stats:FindFirstChild("Network")
        local items = net and net:FindFirstChild("ServerStatsItem")
        pingItem = items and items:FindFirstChild("Data Ping")
        pingGetter = pingItem and pingItem.GetValue
        return type(pingGetter) == "function"
    end
    local function getRealPing()
        local netPing = DW_getnetworkping()
        if netPing and netPing > 0 and netPing < 2000 then return netPing end
        resolvePingItem()
        if not pingItem then return nil end
        local ok, raw = pcall(function()
            -- usa a funcao original (sem o hook) para a predicao continuar com ping real
            if pingSpoofOld then return pingSpoofOld(pingItem) end
            return pingItem:GetValue()
        end)
        raw = ok and tonumber(raw) or nil
        if raw and raw > 0 and raw < 2000 then return raw end
        return nil
    end
    local function getSmoothedPing()
        local now = os.clock()
        if now - lastPingSample < 0.35 then return smoothedPing end
        lastPingSample = now
        local v = getRealPing()
        if v then
            if smoothedPing == 0 then smoothedPing = v
            else smoothedPing = smoothedPing + (v - smoothedPing) * 0.3 end
        end
        return smoothedPing
    end
    -- Ping 0: o ping real nao pode ser zerado pelo cliente. Isto zera o valor
    -- lido pelos scripts do jogo e liga flags de rede que reduzem o atraso real.
    local function setPingSpoof(on)
        cfg.fakePing = false
        if false then
            pcall(function() if _G.FpsOpt and _G.FpsOpt.lowPing then _G.FpsOpt.lowPing(true) end end)
        else
            pcall(function() if _G.FpsOpt and _G.FpsOpt.lowPing then _G.FpsOpt.lowPing(false) end end)
            return true
        end
        if pingSpoofNew or pingSpoofMeta then return true end
        resolvePingItem()
        if not pingItem then return false end
        if type(DW_hookfunction) == "function" and type(pingGetter) == "function" then
            local newGetter = DW_newcclosure(function(...)
                local old = pingSpoofOld
                if old then return old(...) end
                local np = DW_getnetworkping()
                if np then return np end
                return 0
            end)
            local ok, orig = pcall(DW_hookfunction, pingGetter, newGetter)
            if ok then
                -- Executor pode nao devolver a funcao original: nesse caso deixa nil
                -- para nunca chamar o proprio hook (recursao infinita).
                pingSpoofOld = (type(orig) == "function" and orig ~= newGetter and orig) or nil
                pingSpoofNew = newGetter
                return true
            end
        end
        if type(DW_hookmetamethod) == "function" then
            local oldIndex
            local ok, orig = pcall(DW_hookmetamethod, pingItem, "__index", function(t, k)
                if t == pingItem and k == "GetValue" then
                    return function()
                        if cfg.fakePing then return 0 end
                        if oldIndex then
                            local f = oldIndex(t, k)
                            if type(f) == "function" then return f(t) end
                        end
                        return 0
                    end
                end
                if oldIndex then return oldIndex(t, k) end
            end)
            if ok then
                oldIndex = orig
                pingSpoofMeta = true
                return true
            end
        end
        return false
    end

    local function getLeadSeconds()
        if not cfg.prediction then return 0 end
        local ping = getSmoothedPing()
        if ping <= 0 then ping = 60 end
        -- metade do RTT + folga de processamento; teto evita overlead em ping alto
        return math.clamp((ping / 1000) * 0.5, 0, 0.20)
    end

    -- Predicao de 2a ordem: velocidade + aceleracao, recalculada no momento exato
    -- do FireServer (nao no scan de 20Hz). Isso remove o atraso de posicao velha.
    local targetMotion = setmetatable({}, { __mode = "k" })
    -- Predict v3: predicao de 2a ordem + boost proporcional a velocidade.
    -- Geppo/Dash do Blox Fruit chega a 250+ studs/s — o boost compensa o atraso extra.
    local function predict(part)
        if not part or not part.Parent then return part and part.Position or nil end
        if not cfg.prediction then return part.Position end
        local hum = part.Parent:FindFirstChildWhichIsA("Humanoid")
        if not hum or hum.Health <= 0 then return part.Position end
        local now = os.clock()
        local v = part.AssemblyLinearVelocity
        local spd = v.Magnitude
        local prev = targetMotion[part]
        local accel = Vector3.zero
        if prev and (now - prev.t) < 0.18 then
            local dt = math.max(now - prev.t, 1/240)
            accel = (v - prev.v) / dt
            -- cap de aceleracao: evita explosao em teleporte do proprio jogo
            if accel.Magnitude > 600 then accel = accel.Unit * 600 end
        end
        targetMotion[part] = { v = v, t = now }
        if spd < 2 then return part.Position end
        local lead = cfg.predictionAmt + getLeadSeconds()
        -- boost proporcional: a cada dobragem de velocidade acima de 60 studs/s
        -- aumenta o lead em ate 2.2x (cobre dash e geppo sem over-predict em walk)
        if spd > 60 then lead = lead * math.min(spd / 60, 2.2) end
        lead = math.clamp(lead, 0, 0.45)
        return part.Position + v * lead + accel * (0.5 * lead * lead)
    end

    local function getFOVCenter(mode)
        if mode == "V2" then return UserInputService:GetMouseLocation() end
        if not camera then camera = workspace.CurrentCamera end
        return camera.ViewportSize / 2
    end

    local function isValidTarget(hrp, myHRP, mode, radius, fovType, cam)
        if not hrp or not myHRP then return false end
        if mode == "180" then
            local d = (hrp.Position - myHRP.Position).Unit
            if myHRP.CFrame.LookVector:Dot(d) < 0 then return false end
        elseif mode == "FOV" then
            if not cam then cam = workspace.CurrentCamera end
            local sp, on = cam:WorldToViewportPoint(hrp.Position)
            if not on then return false end
            local c = getFOVCenter(fovType)
            if (Vector2.new(sp.X, sp.Y) - c).Magnitude > radius then return false end
        end
        return true
    end

    local function pickBest(candidates, priority, myHRP, cam)
        if #candidates == 0 then return nil end
        local best = candidates[1]
        if priority == "Nearest" then
            for i = 2, #candidates do
                if candidates[i].d < best.d then best = candidates[i] end
            end
        elseif priority == "Low HP" then
            for i = 2, #candidates do
                if candidates[i].hum.Health < best.hum.Health then best = candidates[i] end
            end
        elseif priority == "Looking At Me" then
            local function score(c)
                local dir = (myHRP.Position - c.hrp.Position).Unit
                return c.hrp.CFrame.LookVector:Dot(dir)
            end
            local bs = score(best)
            for i = 2, #candidates do
                local s = score(candidates[i])
                if s > bs then bs = s best = candidates[i] end
            end
        elseif priority == "Crosshair" then
            if not cam then cam = workspace.CurrentCamera end
            local center = cam.ViewportSize / 2
            local function score(c)
                local sp, on = cam:WorldToViewportPoint(c.hrp.Position)
                if not on then return math.huge end
                return (Vector2.new(sp.X, sp.Y) - center).Magnitude
            end
            local bs = score(best)
            for i = 2, #candidates do
                local s = score(candidates[i])
                if s < bs then bs = s best = candidates[i] end
            end
        end
        return best
    end

    -- LoS check: retorna true se existe linha de visao direta entre myHRP e hrp
    -- (sem paredes no caminho). Usa RaycastParams para ignorar chars e agua.
    local losParams = RaycastParams.new()
    losParams.FilterType = Enum.RaycastFilterType.Exclude
    local function hasLoS(myHRP, hrp)
        if not myHRP or not hrp then return true end
        local origin = myHRP.Position
        local target = hrp.Position
        local dir    = target - origin
        local dist   = dir.Magnitude
        if dist < 1 then return true end
        -- exclui os proprios chars para o raycast nao bater neles
        local excl = {}
        for _, pl2 in ipairs(Players:GetPlayers()) do
            if pl2.Character then excl[#excl+1] = pl2.Character end
        end
        if player.Character then excl[#excl+1] = player.Character end
        losParams.FilterDescendantsInstances = excl
        local result = workspace:Raycast(origin, dir.Unit * (dist - 1), losParams)
        -- nenhum hit = linha livre
        return result == nil
    end

    local function scanPlayers(myHRP, mode, radius, fovType, range, priority, cam)
        if not myHRP then return nil end
        local out = {}
        local myPos = myHRP.Position
        local players = Players:GetPlayers()
        for i = 1, #players do
            local pl = players[i]
            if pl ~= player and isEnemy(pl) then
                local char = pl.Character
                if char then
                    local hum = char:FindFirstChildWhichIsA("Humanoid")
                    if hum and hum.Health > 0 then
                        local hrp = partFor(char, cfg.silentPart)
                        if hrp then
                            local skip = false
                            if cfg.ignoreLowLevel then
                                local lvl = getPlayerLevel(pl)
                                if lvl > 0 and lvl < (cfg.ignoreLowLevelThreshold or 2000) then skip = true end
                            end
                            if not skip then
                                local dist = (hrp.Position - myPos).Magnitude
                                if dist <= range and isValidTarget(hrp, myHRP, mode, radius, fovType, cam) then
                                    -- scoring composto: dist normalizada + HP invertido + vel vindo em minha direcao
                                    local vel   = hrp.AssemblyLinearVelocity
                                    local toMe  = (myPos - hrp.Position).Unit
                                    local approach = math.max(vel:Dot(toMe), 0) -- studs/s vindo em minha dir
                                    local score = (dist / range)             -- 0=perto 1=longe
                                              - (approach / 300) * 0.4      -- bonus pra quem esta vindo
                                              + (hum.Health / hum.MaxHealth) * 0.2 -- bonus pra low HP
                                    local los = hasLoS(myHRP, hrp)
                                    out[#out+1] = { pl=pl, hum=hum, hrp=hrp, char=char, d=dist, score=score, los=los }
                                end
                            end
                        end
                    end
                end
            end
        end
        if #out == 0 then return nil end
        -- prefere alvos com LoS; se nenhum tem, pega o de menor score
        local losOnly = {}
        for _, c in ipairs(out) do if c.los then losOnly[#losOnly+1] = c end end
        local pool = #losOnly > 0 and losOnly or out
        -- ordena por score (menor = melhor)
        table.sort(pool, function(a,b) return a.score < b.score end)
        return pool[1]
    end

    local function scanNPCs(myHRP, mode, radius, fovType, range, cam)
        if not myHRP then return nil end
        local folder = workspace:FindFirstChild("Enemies")
        if not folder then return nil end
        local best, bestD = nil, range
        local camPos = myHRP.Position
        local list = folder:GetChildren()
        for i = 1, #list do
            local npc = list[i]
            if npc:IsA("Model") then
                local hum = npc:FindFirstChildWhichIsA("Humanoid")
                if hum and hum.Health > 0 then
                    local hrp = partFor(npc, cfg.silentPart)
                    if hrp then
                        local d = (hrp.Position - camPos).Magnitude
                        if d < bestD and isValidTarget(hrp, myHRP, mode, radius, fovType, cam) then
                            bestD = d
                            best = { npc = npc, hum = hum, hrp = hrp, char = npc, d = d }
                        end
                    end
                end
            end
        end
        return best
    end

    local RAY_EXCLUDE = Enum.RaycastFilterType.Exclude or Enum.RaycastFilterType.Blacklist
    local function soruVisible(part)
        if not cfg.soruWallCheck or not part then return true end
        local params = RaycastParams.new()
        params.FilterType = RAY_EXCLUDE
        params.FilterDescendantsInstances = { player.Character, camera }
        local hit = workspace:Raycast(camera.CFrame.Position, part.Position - camera.CFrame.Position, params)
        return not hit or hit.Instance:IsDescendantOf(part.Parent)
    end

    local function scanSoru(myHRP)
        if not myHRP then return nil end
        local out = {}
        local camPos = myHRP.Position
        local players = Players:GetPlayers()
        for i = 1, #players do
            local pl = players[i]
            if pl ~= player and isEnemy(pl) then
                local char = pl.Character
                if char then
                    local hum = char:FindFirstChildWhichIsA("Humanoid")
                    if hum and hum.Health > 0 then
                        local part = partFor(char, cfg.soruTargetPart)
                        if part then
                            local d = (part.Position - camPos).Magnitude
                            if d <= cfg.soruRange
                                and isValidTarget(part, myHRP, cfg.soruAimMode, cfg.soruFOVRadius, cfg.soruFOVType, camera)
                                and soruVisible(part) then
                                out[#out + 1] = { part = part, hum = hum, d = d, hrp = part }
                            end
                        end
                    end
                end
            end
        end
        if #out == 0 then return nil end
        return pickBest(out, cfg.soruPriority, myHRP, camera)
    end

    local state = {
        playersPos = nil, npcsPos = nil, lockPos = nil,
        playersPart = nil, npcsPart = nil, lockRoot = nil,
        stickyPlayersUntil = 0, stickyNpcsUntil = 0,
        soruPart = nil, soruPos = nil,
        skillTargetRoot = nil, skillTargetHum = nil, skillTargetPos = nil,
    }

    local skillCastUntil = 0
    local function skillCastActive()
        return cfg.skillSilent and cfg.skillAimbot and os.clock() <= skillCastUntil
    end

    local function lockValid()
        if not cfg.targetLockActive then return false end
        local root = cfg.targetLockRoot
        if not root or not root.Parent then return false end
        local hum = root.Parent:FindFirstChildWhichIsA("Humanoid")
        local myHRP = getMyHRP()
        if not hum or hum.Health <= 0 or not myHRP then return false end
        return (root.Position - myHRP.Position).Magnitude <= math.max(cfg.maxRange, cfg.skillAimbotDist)
    end
    local function silentActive()
        return cfg.silentPlayers or cfg.silentNPCs or cfg.targetLockActive or skillCastActive()
    end
    local function aimTarget()
        if cfg.targetLockActive and state.lockRoot and state.lockRoot.Parent then
            return predict(state.lockRoot) or state.lockPos
        end
        if skillCastActive() and state.skillTargetRoot and state.skillTargetRoot.Parent then
            return predict(state.skillTargetRoot) or state.skillTargetPos
        end
        if cfg.silentPlayers and state.playersPart and state.playersPart.Parent then
            return predict(state.playersPart) or state.playersPos
        end
        if cfg.silentNPCs and state.npcsPart and state.npcsPart.Parent then
            return predict(state.npcsPart) or state.npcsPos
        end
        return state.lockPos or state.playersPos or state.npcsPos
    end
    local function canKeepTarget(part, myHRP, mode, radius, fovType, range)
        if not part or not part.Parent then return false end
        local hum = part.Parent:FindFirstChildWhichIsA("Humanoid")
        if not hum or hum.Health <= 0 then return false end
        if (part.Position - myHRP.Position).Magnitude > range then return false end
        return isValidTarget(part, myHRP, mode, radius, fovType, camera)
    end

    local refreshHooks -- definido mais abaixo (forward declaration)
    local lastSkillScan = 0
    local function scanSkillTarget()
        local now = os.clock()
        if now - lastSkillScan < cfg.targetSwitchDelay then
            local root = state.skillTargetRoot
            local hum = state.skillTargetHum
            if root and root.Parent and hum and hum.Health > 0 then
                local myHRP = getMyHRP()
                if myHRP and (root.Position - myHRP.Position).Magnitude <= cfg.skillAimbotDist then return end
            end
            return
        end
        lastSkillScan = now
        local myHRP = getMyHRP()
        if not myHRP then
            state.skillTargetRoot = nil state.skillTargetHum = nil state.skillTargetPos = nil
            return
        end
        if cfg.targetLockActive and cfg.targetLockRoot and cfg.targetLockRoot.Parent then
            local hum = cfg.targetLockRoot.Parent:FindFirstChildWhichIsA("Humanoid")
            if hum and hum.Health > 0 and (cfg.targetLockRoot.Position - myHRP.Position).Magnitude <= cfg.skillAimbotDist then
                state.skillTargetRoot = cfg.targetLockRoot
                state.skillTargetHum = hum
                state.skillTargetPos = predict(cfg.targetLockRoot)
                return
            end
        end
        local mode = cfg.skillAimbotMode
        local bestPl, bestNpc
        if mode == "Both" or mode == "Players Only" then
            bestPl = scanPlayers(myHRP, "360", 0, "V1", cfg.skillAimbotDist, cfg.targetPriority, camera)
        end
        if mode == "Both" or mode == "NPCs Only" then
            bestNpc = scanNPCs(myHRP, "360", 0, "V1", cfg.skillAimbotDist, camera)
        end
        local chosen
        if bestPl and bestNpc then
            chosen = bestPl.d <= bestNpc.d and bestPl or bestNpc
        else
            chosen = bestPl or bestNpc
        end
        if chosen then
            local part = partFor(chosen.char or (chosen.hrp and chosen.hrp.Parent), cfg.lockPart) or chosen.hrp
            state.skillTargetRoot = part
            state.skillTargetHum = chosen.hum
            state.skillTargetPos = predict(part)
        else
            state.skillTargetRoot = nil state.skillTargetHum = nil state.skillTargetPos = nil
        end
    end

    local running = false
    local function startLoop()
        if running then return end
        running = true
        -- RenderStepped: roda toda frame renderizada (60 Hz+), elimina o delay de task.wait
        RunService:BindToRenderStep("DWSilentScan", Enum.RenderPriority.Camera.Value + 1, function()
            if not running then RunService:UnbindFromRenderStep("DWSilentScan") return end
            local blockedNow = (_G.SkillBL and _G.SkillBL.blocked())
                local anySilent = cfg.silentPlayers or cfg.silentNPCs
                local anySoru = cfg.soruEnabled
                local anySkill = cfg.skillAimbot
                local anyLock = cfg.targetLockActive
                if blockedNow then
                    state.playersPos = nil state.npcsPos = nil state.lockPos = nil
                    state.playersPart = nil state.npcsPart = nil state.lockRoot = nil
                    state.soruPart = nil state.soruPos = nil
                    state.skillTargetRoot = nil state.skillTargetHum = nil state.skillTargetPos = nil
                elseif anySilent or anySoru or anySkill or anyLock then
                    local myHRP = getMyHRP()
                    if myHRP then
                        local now = os.clock()
                        if cfg.silentPlayers then
                            local keep = cfg.silentSticky and state.playersPart and now < state.stickyPlayersUntil
                                and canKeepTarget(state.playersPart, myHRP, cfg.aimMode, cfg.fovRadius, cfg.fovMode, cfg.maxRange)
                            if keep then
                                state.playersPos = predict(state.playersPart)
                            else
                                local best = scanPlayers(myHRP, cfg.aimMode, cfg.fovRadius, cfg.fovMode, cfg.maxRange, cfg.targetPriority, camera)
                                state.playersPart = best and best.hrp or nil
                                state.playersPos = best and predict(best.hrp) or nil
                                state.stickyPlayersUntil = now + (cfg.silentSticky and cfg.silentStickyTime or 0)
                            end
                        else
                            state.playersPos = nil state.playersPart = nil
                        end
                        if cfg.silentNPCs then
                            local keep = cfg.silentSticky and state.npcsPart and now < state.stickyNpcsUntil
                                and canKeepTarget(state.npcsPart, myHRP, cfg.aimMode, cfg.fovRadius, cfg.fovMode, cfg.maxRange)
                            if keep then
                                state.npcsPos = predict(state.npcsPart)
                            else
                                local best = scanNPCs(myHRP, cfg.aimMode, cfg.fovRadius, cfg.fovMode, cfg.maxRange, camera)
                                state.npcsPart = best and best.hrp or nil
                                state.npcsPos = best and predict(best.hrp) or nil
                                state.stickyNpcsUntil = now + (cfg.silentSticky and cfg.silentStickyTime or 0)
                            end
                        else
                            state.npcsPos = nil state.npcsPart = nil
                        end
                        if anyLock then
                            if lockValid() then
                                state.lockRoot = cfg.targetLockRoot
                                state.lockPos = predict(cfg.targetLockRoot)
                            else
                                cfg.targetLockActive = false cfg.targetLockRoot = nil cfg.targetLockPlayer = nil
                                state.lockPos = nil state.lockRoot = nil
                                refreshHooks()
                                if module.OnLockLost then pcall(module.OnLockLost) end
                            end
                        else
                            state.lockPos = nil state.lockRoot = nil
                        end
                        if anySkill then scanSkillTarget() end
                        if anySoru then
                            local stickyOK = cfg.soruSticky and state.soruPart and state.soruPart.Parent
                                and state.soruPart.Parent:FindFirstChildWhichIsA("Humanoid")
                                and state.soruPart.Parent.Humanoid.Health > 0
                                and (state.soruPart.Position - myHRP.Position).Magnitude <= cfg.soruRange
                            if stickyOK then
                                local v = state.soruPart.AssemblyLinearVelocity or Vector3.zero
                                state.soruPos = state.soruPart.Position + (cfg.soruPrediction and v * cfg.soruPredAmt or Vector3.zero)
                            else
                                local best = scanSoru(myHRP)
                                if best then
                                    state.soruPart = best.part
                                    local v = best.part.AssemblyLinearVelocity or Vector3.zero
                                    state.soruPos = best.part.Position + (cfg.soruPrediction and v * cfg.soruPredAmt or Vector3.zero)
                                else
                                    state.soruPart = nil state.soruPos = nil
                                end
                            end
                        else
                            state.soruPart = nil state.soruPos = nil
                        end
                    else
                        state.playersPos = nil state.npcsPos = nil state.lockPos = nil
                        state.playersPart = nil state.npcsPart = nil state.lockRoot = nil
                        state.soruPart = nil state.soruPos = nil
                    end
                end
        end)
    end

    local lastFOVDraw = 0
    RunService.RenderStepped:Connect(function()
        local now = os.clock()
        if now - lastFOVDraw < 0.033 then return end
        lastFOVDraw = now
        if FOVCircle then
            if cfg.showFOV and not cfg.stealth then
                FOVCircle.Position = getFOVCenter(cfg.fovMode)
                FOVCircle.Radius = cfg.fovRadius
                FOVCircle.Visible = true
            elseif FOVCircle.Visible then
                FOVCircle.Visible = false
            end
        end
        if SoruFOVCircle then
            if cfg.soruShowFOV and not cfg.stealth then
                SoruFOVCircle.Position = getFOVCenter(cfg.soruFOVType)
                SoruFOVCircle.Radius = cfg.soruFOVRadius
                SoruFOVCircle.Visible = true
            elseif SoruFOVCircle.Visible then
                SoruFOVCircle.Visible = false
            end
        end
    end)

    local SKILL_KEYS = { Z = true, X = true, C = true, V = true, F = true }
    UserInputService.InputBegan:Connect(function(input, gp)
        if gp then return end
        if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
        if SKILL_KEYS[input.KeyCode.Name] then skillCastUntil = os.clock() + 0.9 end
    end)

    local camlockRoot, camlockPos = nil, nil
    local lastCamlockScan = 0
    RunService.RenderStepped:Connect(function()
        if _G.SkillBL and _G.SkillBL.blocked() then return end
        if not cfg.skillCamLock and not cfg.permanentCamLock then
            camlockRoot = nil camlockPos = nil
            return
        end
        local root, targetPos
        if lockValid() then
            root = cfg.targetLockRoot
            targetPos = predict(root) or state.lockPos or root.Position
        elseif cfg.skillAimbot and state.skillTargetRoot and state.skillTargetRoot.Parent then
            root = state.skillTargetRoot
            targetPos = predict(root) or state.skillTargetPos or root.Position
        elseif cfg.permanentCamLock then
            local now = os.clock()
            if camlockRoot and camlockRoot.Parent then
                local hum = camlockRoot.Parent:FindFirstChildWhichIsA("Humanoid")
                if not hum or hum.Health <= 0 then camlockRoot = nil end
            end
            if not camlockRoot or now - lastCamlockScan > 0.4 then
                lastCamlockScan = now
                local myHRP = getMyHRP()
                if myHRP then
                    local best = scanPlayers(myHRP, "360", 0, "V1", cfg.maxRange, cfg.targetPriority, camera)
                    if best then
                        local partName = cfg.lockPart or "HumanoidRootPart"
                        camlockRoot = best.hrp.Parent:FindFirstChild(partName) or best.hrp
                        camlockPos = predict(camlockRoot)
                    else
                        camlockRoot = nil
                    end
                end
            end
            if camlockRoot and camlockRoot.Parent then
                root = camlockRoot
                targetPos = predict(camlockRoot) or camlockRoot.Position
            end
        end
        if not root or not root.Parent then return end
        local hum = root.Parent and root.Parent:FindFirstChildWhichIsA("Humanoid")
        if not hum or hum.Health <= 0 then camlockRoot = nil return end
        local shouldLock = cfg.permanentCamLock or (cfg.skillCamLock and os.clock() <= skillCastUntil)
        if not shouldLock then return end
        local cam = workspace.CurrentCamera
        local camPos = cam.CFrame.Position
        targetPos = targetPos or root.Position
        if (targetPos - camPos).Magnitude > 0.1 then
            if cfg.camSmoothness == "Instant" then
                cam.CFrame = CFrame.new(camPos, targetPos)
            elseif cfg.camSmoothness == "Very Smooth" then
                cam.CFrame = cam.CFrame:Lerp(CFrame.new(camPos, targetPos), 0.08)
            else
                cam.CFrame = cam.CFrame:Lerp(CFrame.new(camPos, targetPos), 0.18)
            end
        end
    end)

    -- Substitui Vector3 dentro de tabelas de hit (ex: {target, part}) sem
    -- trocar CFrame de movimento nem outros tipos usados pelo jogo.
    local function replacePos(v, pos, depth)
        if typeof(v) == "Vector3" then return pos, true end
        depth = depth or 0
        if depth < 2 and type(v) == "table" then
            local out, changed = {}, false
            for k, val in pairs(v) do
                local nv, ch = replacePos(val, pos, depth + 1)
                out[k] = nv
                if ch then changed = true end
            end
            if changed then return out, true end
            return v, false
        end
        return v, false
    end
    local Mouse = player:GetMouse()
    -- OPT: hooks no metatable do game so ficam instalados enquanto algum recurso de mira esta ligado.
    -- Antes ficavam instalados desde o load, e o __index do game roda em TODA leitura de propriedade do jogo.
    local gameHook = { installed = false, mt = nil, oldNamecall = nil, oldIndex = nil, myNamecall = nil, myIndex = nil, viaHookMeta = false }
    local function aimHooksNeeded()
        return cfg.silentPlayers or cfg.silentNPCs or cfg.soruEnabled or cfg.targetLockActive or (cfg.skillSilent and cfg.skillAimbot)
    end
    local function callOld(old, self, ...)
        if old then return old(self, ...) end
        local method = DW_getnamecallmethod and DW_getnamecallmethod() or nil
        if method then
            local ok, f = pcall(function() return self[method] end)
            if ok and type(f) == "function" then return f(self, ...) end
        end
        return nil
    end
    local function namecallHandler(oldNamecall, self, ...)
        local method = DW_getnamecallmethod and DW_getnamecallmethod() or nil
        if method and method ~= "FireServer" and method ~= "InvokeServer" then return callOld(oldNamecall, self, ...) end
        if not method then
            -- Executor sem getnamecallmethod: limita a remotes para nao alterar
            -- Vector3 de chamadas normais do jogo.
            local okCls, cls = pcall(function() return self.ClassName end)
            if not okCls or (cls ~= "RemoteEvent" and cls ~= "RemoteFunction" and cls ~= "UnreliableRemoteEvent") then
                return callOld(oldNamecall, self, ...)
            end
        end
        local silentOn = silentActive()
        local soruOn = cfg.soruEnabled
        if (not silentOn) and (not soruOn) then return callOld(oldNamecall, self, ...) end
        if _G.SkillBL and _G.SkillBL.blocked() then return callOld(oldNamecall, self, ...) end
        local args = { ... }
        local changed = false
        if silentOn then
            local targetPos = aimTarget()
            if targetPos then
                for i = 1, #args do
                    local nv, ch = replacePos(args[i], targetPos, 0)
                    if ch then args[i] = nv changed = true end
                end
            end
        end
        if soruOn and state.soruPos then
            for i = 1, #args do
                if type(args[i]) == "string" and args[i] == "C" then
                    for j = 1, #args do
                        if typeof(args[j]) == "Vector3" then args[j] = state.soruPos changed = true end
                    end
                    break
                end
            end
        end
        -- Silent TP: teleporta o HRP perto do alvo (maximo 999 studs configuravel)
        -- antes de disparar o FireServer, garantindo que o servidor registre o hit.
        if changed and cfg.silentTP then
            local targetPos = aimTarget()
            if targetPos then
                local myChar = player.Character
                local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
                if myHRP then
                    local dist = (targetPos - myHRP.Position).Magnitude
                    if dist > cfg.silentTPDist then
                        -- guarda pos original
                        local origCF = myHRP.CFrame
                        local dir = (targetPos - myHRP.Position).Unit
                        local newPos = targetPos - dir * math.min(cfg.silentTPDist - 1, dist - 1)
                        pcall(function() myHRP.CFrame = CFrame.new(newPos, targetPos) end)
                        callOld(oldNamecall, self, DW_unpack(args))
                        -- volta imediatamente (invisivel para o servidor, nao envia pos de volta)
                        pcall(function() myHRP.CFrame = origCF end)
                        return
                    end
                end
            end
        end
        if changed then return callOld(oldNamecall, self, DW_unpack(args)) end
        return callOld(oldNamecall, self, ...)
    end
    local function indexHandler(oldIndex, tbl, k)
        if tbl == Mouse then
            if _G.SkillBL and _G.SkillBL.blocked() then return oldIndex(tbl, k) end
            if cfg.soruEnabled and state.soruPos and k == "Hit" then return CFrame.new(state.soruPos) end
            if silentActive() then
                local pos = aimTarget()
                if pos then
                    if k == "Hit" then return CFrame.new(pos) end
                    if k == "Target" then return nil end
                    if k == "X" then return camera:WorldToViewportPoint(pos).X end
                    if k == "Y" then return camera:WorldToViewportPoint(pos).Y end
                    if k == "UnitRay" then
                        local origin = camera.CFrame.Position
                        return Ray.new(origin, (pos - origin).Unit)
                    end
                end
            end
        end
        return oldIndex(tbl, k)
    end
    local function installGameHooks()
        if gameHook.installed then return true end
        if gameHook.viaHookMeta and gameHook.myNamecall then gameHook.installed = true return true end
        local mt, oldNamecall, oldIndex
        if type(DW_getrawmetatable) == "function" then
            local okMeta, m = pcall(DW_getrawmetatable, game)
            if okMeta and m then
                mt = m
                oldNamecall = m.__namecall
                oldIndex = m.__index
            end
        end
        if mt and (type(oldNamecall) == "function" or type(oldIndex) == "function") then
            if DW_setreadonly then pcall(DW_setreadonly, mt, false) end
            local myNamecall = type(oldNamecall) == "function" and DW_newcclosure(function(self, ...) return namecallHandler(oldNamecall, self, ...) end) or nil
            local myIndex = type(oldIndex) == "function" and DW_newcclosure(function(tbl, k) return indexHandler(oldIndex, tbl, k) end) or nil
            local okAssign = pcall(function()
                if myNamecall then mt.__namecall = myNamecall end
                if myIndex then mt.__index = myIndex end
            end)
            if not okAssign then
                -- volta a escrita para desfazer o que entrou pela metade
                pcall(function()
                    if myNamecall and rawget(mt, "__namecall") == myNamecall then mt.__namecall = oldNamecall end
                    if myIndex and rawget(mt, "__index") == myIndex then mt.__index = oldIndex end
                end)
            end
            if DW_setreadonly then pcall(DW_setreadonly, mt, true) end
            if okAssign then
                gameHook.installed = true
                gameHook.mt = mt
                gameHook.oldNamecall, gameHook.oldIndex = oldNamecall, oldIndex
                gameHook.myNamecall, gameHook.myIndex = myNamecall, myIndex
                return true
            end
        end
        -- Fallback para executores sem getrawmetatable: hookmetamethod direto no __namecall.
        if type(DW_hookmetamethod) == "function" and type(DW_getnamecallmethod) == "function" then
            local oldNC
            local myNamecall = DW_newcclosure(function(self, ...)
                return namecallHandler(oldNC, self, ...)
            end)
            local okNC, origNC = pcall(DW_hookmetamethod, game, "__namecall", myNamecall)
            if okNC then
                oldNC = (type(origNC) == "function" and origNC) or nil
                gameHook.installed = true
                gameHook.viaHookMeta = true
                gameHook.myNamecall = myNamecall
                return true
            end
        end
        return false
    end
    local function removeGameHooks()
        if not gameHook.installed then return end
        if gameHook.viaHookMeta then
            -- hookmetamethod nao tem unhook portavel; deixa passthrough barato.
            gameHook.installed = false
            return
        end
        local mt = gameHook.mt
        if not mt then gameHook.installed = false return end
        pcall(function()
            if DW_setreadonly then pcall(DW_setreadonly, mt, false) end
            -- so desfaz se ninguem (ex: Gun Click SL) empilhou outro hook por cima; se empilhou, deixa passthrough
            if gameHook.myIndex and rawget(mt, "__index") == gameHook.myIndex then mt.__index = gameHook.oldIndex end
            if gameHook.myNamecall and rawget(mt, "__namecall") == gameHook.myNamecall then mt.__namecall = gameHook.oldNamecall end
            if DW_setreadonly then pcall(DW_setreadonly, mt, true) end
        end)
        gameHook.installed = false
    end
    -- Se o executor nao tem getrawmetatable/hook, a mira ainda funciona movendo a camera.
    local fallbackBound = false
    local function fallbackAimStep()
        if gameHook.installed then return end
        if not (cfg.silentPlayers or cfg.silentNPCs or cfg.skillAimbot) then return end
        if not silentActive() then return end
        if cfg.skillCamLock or cfg.permanentCamLock then return end
        local skillOnly = not (cfg.silentPlayers or cfg.silentNPCs)
        if skillOnly and not skillCastActive() then return end
        local pos = aimTarget()
        if not pos then return end
        local cam = workspace.CurrentCamera
        if not cam then return end
        local camPos = cam.CFrame.Position
        if (pos - camPos).Magnitude > 0.1 then
            cam.CFrame = cam.CFrame:Lerp(CFrame.new(camPos, pos), 0.35)
        end
    end
    local function ensureFallbackAim()
        local need = (cfg.silentPlayers or cfg.silentNPCs or cfg.skillAimbot) and not gameHook.installed
        if need and not fallbackBound then
            local ok = pcall(function()
                RunService:BindToRenderStep("HardyWareFallbackAim", Enum.RenderPriority.Camera.Value + 10, fallbackAimStep)
            end)
            fallbackBound = ok
        elseif not need and fallbackBound then
            pcall(function() RunService:UnbindFromRenderStep("HardyWareFallbackAim") end)
            fallbackBound = false
        end
    end
    refreshHooks = function()
        pcall(function()
            if aimHooksNeeded() then installGameHooks() else removeGameHooks() end
        end)
        pcall(ensureFallbackAim)
    end

    task.spawn(function()
        local ok, MouseModule = pcall(function()
            local modules = RS:FindFirstChild("Modules")
            return modules and require(modules:FindFirstChild("Mouse"))
        end)
        if not ok or not MouseModule then return end
        if type(DW_getrawmetatable) ~= "function" then return end
        local okMeta, mt = pcall(DW_getrawmetatable, MouseModule)
        if not okMeta or not mt or type(mt.__index) ~= "function" then return end
        local oldIndex, oldNewIndex = mt.__index, mt.__newindex
        if DW_setreadonly then pcall(DW_setreadonly, mt, false) end
        local storage = {
            Hit = rawget(MouseModule, "Hit"), X = rawget(MouseModule, "X"),
            Y = rawget(MouseModule, "Y"), Target = rawget(MouseModule, "Target"),
        }
        local newIndex = DW_newcclosure(function(tbl, k)
            if tbl == MouseModule and _G.SkillBL and _G.SkillBL.blocked() then return oldIndex(tbl, k) end
            if tbl == MouseModule and silentActive() then
                local pos = aimTarget()
                if pos then
                    if k == "Hit" then return CFrame.new(pos) end
                    if k == "Target" then return nil end
                    if k == "X" then return camera:WorldToViewportPoint(pos).X end
                    if k == "Y" then return camera:WorldToViewportPoint(pos).Y end
                end
            end
            if tbl == MouseModule and cfg.soruEnabled and state.soruPos and k == "Hit" then
                return CFrame.new(state.soruPos)
            end
            return oldIndex(tbl, k)
        end)
        local newNewIndex = DW_newcclosure(function(tbl, k, v)
            if tbl == MouseModule and (k == "Hit" or k == "X" or k == "Y" or k == "Target") then
                storage[k] = v
                return
            end
            if oldNewIndex then return oldNewIndex(tbl, k, v) end
            rawset(tbl, k, v)
        end)
        rawset(MouseModule, "Hit", nil)
        rawset(MouseModule, "X", nil)
        rawset(MouseModule, "Y", nil)
        rawset(MouseModule, "Target", nil)
        if DW_setreadonly then pcall(DW_setreadonly, mt, false) end
        local okSet = pcall(function()
            mt.__index = newIndex
            mt.__newindex = newNewIndex
        end)
        if DW_setreadonly then pcall(DW_setreadonly, mt, true) end
        if not okSet then
            -- nao deixa o modulo Mouse sem os campos originais se o hook falhar
            pcall(function()
                for k,v in pairs(storage) do rawset(MouseModule,k,v) end
            end)
        end
    end)

    local function buildRay(pos)
        if not pos then return nil end
        local origin = camera.CFrame.Position
        return Ray.new(origin, (pos - origin).Unit)
    end
    local oldSPR, oldVPR
    task.spawn(function()
        if type(DW_hookfunction) ~= "function" then return end
        if not camera then return end
        local function makeRayHook(which)
            return DW_newcclosure(function(...)
                if silentActive() then
                    local r = buildRay(aimTarget())
                    if r then return r end
                end
                if cfg.soruEnabled and state.soruPos then
                    local r = buildRay(state.soruPos)
                    if r then return r end
                end
                -- oldSPR/oldVPR ficam fora do hook: dentro do inicializador do
                -- propio local o nome cairia no global (nil) e quebraria o raycast.
                local old = (which == "spr") and oldSPR or oldVPR
                if type(old) == "function" then return old(...) end
                return Ray.new(camera.CFrame.Position, camera.CFrame.LookVector)
            end)
        end
        local targetSPR = camera.ScreenPointToRay
        local okSPR, origSPR = pcall(DW_hookfunction, targetSPR, makeRayHook("spr"))
        if okSPR then
            if type(origSPR) == "function" then
                oldSPR = origSPR
            elseif type(restorefunction) == "function" then
                pcall(restorefunction, targetSPR)
            end
        end
        local targetVPR = camera.ViewportPointToRay
        local okVPR, origVPR = pcall(DW_hookfunction, targetVPR, makeRayHook("vpr"))
        if okVPR then
            if type(origVPR) == "function" then
                oldVPR = origVPR
            elseif type(restorefunction) == "function" then
                pcall(restorefunction, targetVPR)
            end
        end
    end)

    function module:ToggleTargetLock()
        if cfg.targetLockActive then
            cfg.targetLockActive = false cfg.targetLockRoot = nil cfg.targetLockPlayer = nil
            state.lockPos = nil
            refreshHooks()
            return false, "Target unlocked."
        end
        local myHRP = getMyHRP()
        if not myHRP then return false, "No character." end
        local range = math.max(cfg.maxRange, cfg.skillAimbotDist)
        local best = scanPlayers(myHRP, "360", 0, "V1", range, "Crosshair", camera)
        if not best then best = scanNPCs(myHRP, "360", 0, "V1", range, camera) end
        if not best then return false, "No eligible target." end
        local root = partFor(best.char or (best.hrp and best.hrp.Parent), cfg.lockPart) or best.hrp
        cfg.targetLockActive = true
        cfg.targetLockRoot = root
        cfg.targetLockPlayer = Players:GetPlayerFromCharacter(root.Parent)
        state.lockRoot = root
        state.lockPos = predict(root) or root.Position
        refreshHooks()
        startLoop()
        return true, "Locked: " .. tostring(root.Parent and root.Parent.Name)
    end
    function module:SetPlayerSilentAim(s) cfg.silentPlayers = s state.playersPart = nil state.playersPos = nil state.stickyPlayersUntil = 0 refreshHooks() startLoop() end
    function module:SetNPCSilentAim(s) cfg.silentNPCs = s state.npcsPart = nil state.npcsPos = nil state.stickyNpcsUntil = 0 refreshHooks() startLoop() end
    function module:SetAimMode(m) cfg.aimMode = m state.playersPart = nil state.npcsPart = nil end
    function module:SetTargetPriority(p) cfg.targetPriority = p end
    function module:SetShowFOVCircle(s) cfg.showFOV = s end
    function module:SetFOVRadius(n) cfg.fovRadius = n end
    function module:SetFOVMode(m) cfg.fovMode = m end
    function module:SetDistanceLimit(n) if type(n) == "number" then cfg.maxRange = n end end
    function module:SetSilentPart(p) cfg.silentPart = p state.playersPart = nil state.npcsPart = nil end
    function module:SetPrediction(v) cfg.prediction = v end
    function module:SetPredictionAmount(n) if type(n) == "number" then cfg.predictionAmt = math.clamp(n, 0, 0.30) end end
    function module:SetSilentSticky(v) cfg.silentSticky = v state.playersPart = nil state.npcsPart = nil end
    function module:SetSkillAimbot(s) cfg.skillAimbot = s if s then lastSkillScan = 0 else state.skillTargetRoot = nil state.skillTargetHum = nil state.skillTargetPos = nil end refreshHooks() startLoop() end
    function module:SetSkillSilent(s) cfg.skillSilent = s refreshHooks() end
    function module:SetSilentTP(v) cfg.silentTP = v == true end
    function module:SetSilentTPDist(n) if type(n) == "number" then cfg.silentTPDist = math.clamp(n, 1, 9999) end end
    function module:SetSkillCamLock(s) cfg.skillCamLock = s ensureFallbackAim() end
    function module:SetPermanentCamLock(s) cfg.permanentCamLock = s ensureFallbackAim() end
    function module:GetAimBackend()
        if gameHook.installed then return "hook" end
        if fallbackBound then return "camera" end
        if cfg.skillCamLock or cfg.permanentCamLock then return "camlock" end
        return "off"
    end
    function module:SetSkillAimbotDist(n) cfg.skillAimbotDist = n end
    function module:SetSkillAimbotMode(m) cfg.skillAimbotMode = m end
    function module:SetTargetSwitchDelay(n) if type(n) == "number" then cfg.targetSwitchDelay = math.clamp(n, 0.03, 1) end end
    function module:SetSoruAutoAim(s)
        cfg.soruEnabled = s
        state.soruPart = nil state.soruPos = nil
        refreshHooks()
        startLoop()
    end
    function module:SetSoruRange(n) cfg.soruRange = n end
    function module:SetSoruAimMode(m) cfg.soruAimMode = m end
    function module:SetSoruFOVType(m) cfg.soruFOVType = m end
    function module:SetSoruFOVRadius(n) cfg.soruFOVRadius = n end
    function module:SetSoruPriority(p) cfg.soruPriority = p end
    function module:SetSoruShowFOVCircle(s) cfg.soruShowFOV = s end
    function module:SetSoruPrediction(s) cfg.soruPrediction = s end
    function module:SetSoruPredictionAmount(n) cfg.soruPredAmt = n end
    function module:SetSoruStickyTarget(s) cfg.soruSticky = s if not s then state.soruPart = nil end end
    function module:SetSoruWallCheck(s) cfg.soruWallCheck = s end
    function module:SetSoruTargetPart(p) cfg.soruTargetPart = p state.soruPart = nil end
    function module:SetTeamCheck(v) cfg.teamCheck = v enemyCache = {} end
    function module:SetSafeZoneCheck(v) cfg.safeZoneCheck = v protectCache = {} end
    function module:SetIgnoreLowLevel(v) cfg.ignoreLowLevel = v end
    function module:SetIgnoreLowLevelThreshold(n) cfg.ignoreLowLevelThreshold = n end
    function module:SetLockPart(p) cfg.lockPart = p state.skillTargetRoot = nil state.skillTargetPos = nil state.lockRoot = nil state.lockPos = nil end
    function module:SetCamSmoothness(s) cfg.camSmoothness = s end
    function module:GetPing() return getSmoothedPing() end
    function module:GetRealPing() return getRealPing() or getSmoothedPing() end
    function module:GetDisplayPing() return getSmoothedPing() end
    function module:IsFakePing() return false end
    function module:SetFakePing(v) end -- [REMOVED: fakePing]
    function module:SetStealth(v)
        cfg.stealth = v and true or false
        if cfg.stealth then
            if FOVCircle then FOVCircle.Visible = false end
            if SoruFOVCircle then SoruFOVCircle.Visible = false end
        end
    end
    function module:SetTracerEnabled(v)
        cfg.tracerEnabled = v
        if not v and _tracerLine then _tracerLine.Visible = false end
    end
    function module:SetTracerColor(name) cfg.tracerColorName = name end

    do
        local _tColors = {
            Red = Color3.fromRGB(255, 70, 85), Orange = Color3.fromRGB(255, 150, 70),
            Purple = Color3.fromRGB(175, 115, 255), Cyan = Color3.fromRGB(65, 220, 245),
            Green = Color3.fromRGB(80, 225, 140), Blue = Color3.fromRGB(80, 150, 255),
            Yellow = Color3.fromRGB(255, 225, 90), Pink = Color3.fromRGB(255, 130, 190),
            White = Color3.new(1, 1, 1),
        }
        local _tGui = Instance.new("ScreenGui")
        _tGui.Name = "PvpAimTracerGui"
        _tGui.ResetOnSpawn = false
        _tGui.IgnoreGuiInset = true
        _tGui.DisplayOrder = 120
        _tGui.Enabled = true
        do
            local h = DW_safe_gui_parent()
            if h then _tGui.Parent = h end
        end
        module._tracerGui = _tGui

        local _tracerFrames = {}
        local _tracerGui = _tGui

        local function _getTracerOrigin(cam)
            local char = player.Character
            if not char then
                local vp = cam.ViewportSize
                return Vector2.new(vp.X * 0.5, vp.Y * 0.5)
            end
            local torso = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso") or char:FindFirstChild("HumanoidRootPart")
            if torso then
                local chestWorld = torso.Position + Vector3.new(0, 0.6, 0)
                local pOrigin, onScreen = cam:WorldToViewportPoint(chestWorld)
                if onScreen and pOrigin.Z > 0 then return Vector2.new(pOrigin.X, pOrigin.Y) end
            end
            local vp = cam.ViewportSize
            return Vector2.new(vp.X * 0.5, vp.Y * 0.5)
        end

        local function _projectTracer(cam, position)
            if not cam or not position then return nil end
            local p, visible = cam:WorldToViewportPoint(position)
            local vp = cam.ViewportSize
            if not visible or p.Z <= 0 or vp.X < 1 or vp.Y < 1 then return nil end
            if p.X ~= p.X or p.Y ~= p.Y then return nil end
            local tx = math.clamp(p.X, 0, vp.X)
            local ty = math.clamp(p.Y, 0, vp.Y)
            local from = _getTracerOrigin(cam)
            local to = Vector2.new(tx, ty)
            local delta = to - from
            if delta.Magnitude < 1 then return nil end
            return (from + to) / 2, delta.Magnitude, math.deg(math.atan2(delta.Y, delta.X))
        end

        local function _hideTracers()
            for _, ln in pairs(_tracerFrames) do ln.Visible = false end
        end

        local function _drawTracer(model, cam, col)
            local root = model and (model:FindFirstChild("UpperTorso") or model:FindFirstChild("Torso") or model:FindFirstChild("HumanoidRootPart"))
            local hum = model and model:FindFirstChildOfClass("Humanoid")
            if not root or not hum or hum.Health <= 0 then return end
            local targetPos = root.Position + Vector3.new(0, 0.4, 0)
            local midpoint, length, angle = _projectTracer(cam, targetPos)
            if not midpoint then return end
            local ln = _tracerFrames[model]
            if not ln then
                ln = Instance.new("Frame", _tracerGui)
                ln.Name = "TargetLine"
                ln.AnchorPoint = Vector2.new(0.5, 0.5)
                ln.BorderSizePixel = 0
                ln.Active = false
                ln.BackgroundTransparency = 0.1
                _tracerFrames[model] = ln
            end
            ln.Position = UDim2.fromOffset(midpoint.X, midpoint.Y)
            ln.Size = UDim2.fromOffset(length, 1.5)
            ln.Rotation = angle
            ln.BackgroundColor3 = col
            ln.Visible = true
        end

        local lastTracerScan = 0
        local tracerRoot = nil
        task.spawn(function()
            while true do
                if cfg.tracerEnabled then
                    local now = os.clock()
                    if now - lastTracerScan > 0.08 then
                        lastTracerScan = now
                        local myHRP = getMyHRP()
                        if myHRP then
                            local best = scanPlayers(myHRP, "360", 0, "V1", cfg.maxRange, cfg.targetPriority, camera)
                            tracerRoot = best and best.hrp or nil
                        else
                            tracerRoot = nil
                        end
                    end
                    if tracerRoot and tracerRoot.Parent then
                        local _pl = Players:GetPlayerFromCharacter(tracerRoot.Parent)
                        if _pl and isProtected(_pl) then tracerRoot = nil end
                    end
                else
                    tracerRoot = nil
                end
                task.wait(cfg.tracerEnabled and 0.06 or 0.25)
            end
        end)

        RunService.RenderStepped:Connect(function()
            if not cfg.tracerEnabled or cfg.stealth then
                if next(_tracerFrames) then _hideTracers() end
                return
            end
            _hideTracers()
            for model, ln in pairs(_tracerFrames) do
                if not model.Parent then ln:Destroy() _tracerFrames[model] = nil end
            end
            local cam = workspace.CurrentCamera
            if not cam then return end
            local char = player.Character
            if not char or not char:FindFirstChild("HumanoidRootPart") then return end
            local root = nil
            if lockValid() then root = cfg.targetLockRoot end
            if not root and state.skillTargetRoot and state.skillTargetRoot.Parent then
                local _pl = Players:GetPlayerFromCharacter(state.skillTargetRoot.Parent)
                if not (_pl and isProtected(_pl)) then root = state.skillTargetRoot end
            end
            if not root and tracerRoot and tracerRoot.Parent then
                local _pl = Players:GetPlayerFromCharacter(tracerRoot.Parent)
                if not (_pl and isProtected(_pl)) then
                    root = tracerRoot
                else
                    tracerRoot = nil
                end
            end
            if not root then return end
            local model = root.Parent
            if not model then return end
            local col = _tColors[cfg.tracerColorName] or _tColors.Purple
            _tracerColor = col
            _drawTracer(model, cam, col)
        end)
    end

    return module
end)()
_G.SilentAimModule = SilentAimModule
local M1Extender=(function()local M={}local active=false local maxRange=50 local function getTarget()local myChar=player.Character local myRoot=myChar and myChar:FindFirstChild("HumanoidRootPart")if not myRoot then return nil end local target,shortestDist=nil,maxRange local folders={workspace:FindFirstChild("Enemies"),workspace:FindFirstChild("Characters")}for _,folder in pairs(folders)do if folder then for _,v in pairs(folder:GetChildren())do local eRoot=v:FindFirstChild("HumanoidRootPart")local eHum=v:FindFirstChildOfClass("Humanoid")if v~=myChar and eRoot and eHum and eHum.Health>0 then local dist=(eRoot.Position-myRoot.Position).Magnitude if dist<shortestDist then shortestDist=dist target=v end end end end end return target end
UserInputService.InputBegan:Connect(function(input,processed)if processed or not active then return end if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then local target=getTarget()local tool=player.Character and player.Character:FindFirstChildOfClass("Tool")if target and tool and RS_RegisterHit and RS_RegisterAttack then local head=target:FindFirstChild("Head")or target:FindFirstChild("HumanoidRootPart")if head then local sessionId=tostring(player.UserId):sub(2,4)..tostring(tick()):sub(-5)pcall(function()RS_RegisterAttack:FireServer()local hitData={}for _,part in pairs(target:GetChildren())do if part:IsA("BasePart")then table.insert(hitData,{target,part})end end RS_RegisterHit:FireServer(head,hitData,{},sessionId)end)end end end end)
function M:Toggle(v)active=v end
function M:SetRange(v)maxRange=v end
return M end)()
_G.M1Extender=M1Extender
_G.FastAttackMod=(function()
local M={}
local enabled=false
local delay=0.15
local lastTick=0
local function getTargets(myPos)
    local list={}
    local enemies=workspace:FindFirstChild("Enemies")
    if enemies then
        for _,npc in ipairs(enemies:GetChildren()) do
            local hum=npc:FindFirstChildOfClass("Humanoid")
            local hrp=npc:FindFirstChild("HumanoidRootPart")
            local head=npc:FindFirstChild("Head") or hrp
            if hum and hum.Health>0 and hrp and head and (hrp.Position-myPos).Magnitude<=120 then table.insert(list,{npc,head}) end
        end
    end
    for _,p in ipairs(Players:GetPlayers()) do
        local ch=p.Character
        if p~=player and ch then
            local hum=ch:FindFirstChildOfClass("Humanoid")
            local hrp=ch:FindFirstChild("HumanoidRootPart")
            local head=ch:FindFirstChild("Head") or hrp
            if hum and hum.Health>0 and hrp and head and (hrp.Position-myPos).Magnitude<=120 then table.insert(list,{ch,head}) end
        end
    end
    return list
end
local function burst()
    local char=player.Character
    local hrp=char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local busy=char:GetAttribute("isUsingSkill") or char:GetAttribute("UsingSkill") or char:GetAttribute("Busy")
    if busy==true then return end
    local tool=char:FindFirstChildOfClass("Tool")
    if not tool or tool.ToolTip=="Gun" then return end
    local myPos=hrp.Position
    local list=getTargets(myPos)
    if #list==0 then return end
    local trimmed={}
    for i=1,math.min(#list,3) do table.insert(trimmed,list[i]) end
    local primary=trimmed[1][2]
    local diff=primary.Position-myPos
    local aim=(diff.Magnitude>0.05 and diff.Unit) or Vector3.new(0,0,-1)
    pcall(function()
        if tool:FindFirstChild("LeftClickRemote") then
            tool.LeftClickRemote:FireServer(aim,1)
        elseif RS_RegisterHit and RS_RegisterAttack then
            RS_RegisterAttack:FireServer(0)
            RS_RegisterHit:FireServer(primary,trimmed)
        end
    end)
end
function M:Toggle(v) enabled=v end
function M:SetDelay(v)
    local n=tonumber(string.match(v,"[%d%.]+")) or 0.15
    delay=math.clamp(n,0.12,1)
end
RunService.Heartbeat:Connect(function()
    if not enabled then return end
    local now=tick()
    if now-lastTick<math.max(delay,0.12) then return end
    lastTick=now
    burst()
end)
return M
end)()
local GunClickSL=(function()local enabled=false local aimPos=nil local hookInstalled=false local function getClosestTarget()local char=player.Character if not char then return nil end local root=char:FindFirstChild("HumanoidRootPart")if not root then return nil end local closest,dist=nil,math.huge local myPos=root.Position for _,pl in ipairs(Players:GetPlayers())do if pl~=player and pl.Character then local targetPart=pl.Character:FindFirstChild("HumanoidRootPart")if targetPart then local hum=pl.Character:FindFirstChildOfClass("Humanoid")if hum and hum.Health>0 then local d=(targetPart.Position-myPos).Magnitude if d<dist then dist=d closest=targetPart end end end end end return closest end
local function installHook()
    if hookInstalled then return end
    if type(DW_getrawmetatable)~="function" then return end
    local okMeta,mt=pcall(DW_getrawmetatable,game)
    if not okMeta or not mt then return end
    local oldNamecall=mt.__namecall
    if type(oldNamecall)~="function" then return end
    if DW_setreadonly then pcall(DW_setreadonly,mt,false) end
    local hook=DW_newcclosure(function(self,...)
        if not enabled or not aimPos then return oldNamecall(self,...) end
        local method=DW_getnamecallmethod()
        if method and method~="FireServer" then return oldNamecall(self,...) end
        local remoteName=tostring(self.Name or self)
        if not remoteName:find("ShootGunEvent") then return oldNamecall(self,...) end
        local args={...}
        local changed=false
        if typeof(args[1])=="Vector3" then args[1]=aimPos.Position changed=true end
        if typeof(args[2])=="table" then args[2]={[1]=aimPos} changed=true end
        if changed then return oldNamecall(self,DW_unpack(args)) end
        return oldNamecall(self,...)
    end)
    local okSet=pcall(function() mt.__namecall=hook end)
    if DW_setreadonly then pcall(DW_setreadonly,mt,true) end
    if okSet then hookInstalled=true end
end
local function startLoop()task.spawn(function()while enabled do aimPos=getClosestTarget()task.wait(0.05)end end)end
local M={}
function M:SetEnabled(state)if state==enabled then return end enabled=state if state then aimPos=nil installHook()startLoop()else aimPos=nil end end
return M end)()
_G.GunClickSL=GunClickSL
local notifGui
local function ensureNotifGui()if notifGui and notifGui.Parent then return notifGui end notifGui=Instance.new("ScreenGui")notifGui.Name="HardyWareNotifs"notifGui.ResetOnSpawn=false notifGui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling notifGui.IgnoreGuiInset=true notifGui.Parent=guiParent return notifGui end
local activeNotifs={}
local function notify(title,text,duration)if _G.__DWStealth then return end duration=duration or 3 local parent=ensureNotifGui()local h,gap=68,8 local y=16+(#activeNotifs*(h+gap))local frame=Instance.new("Frame")frame.Size=UDim2.new(0,300,0,h)frame.Position=UDim2.new(0,-280,1,-y-h)frame.BackgroundColor3=Color3.fromRGB(10,6,12)frame.BorderSizePixel=0 frame.ZIndex=50 frame.Parent=parent round(frame,14)line(frame,C.PinkSoft,1.4,0.25)local accentBar=Instance.new("Frame")accentBar.Size=UDim2.new(0,4,1,-16)accentBar.Position=UDim2.new(0,6,0,8)accentBar.BackgroundColor3=C.Pink accentBar.BorderSizePixel=0 accentBar.ZIndex=52 accentBar.Parent=frame round(accentBar,2)local tLabel=Instance.new("TextLabel")tLabel.Size=UDim2.new(1,-24,0,22)tLabel.Position=UDim2.new(0,18,0,10)tLabel.BackgroundTransparency=1 tLabel.Text=title or "HardyWare"tLabel.TextColor3=Color3.fromRGB(245,238,255)tLabel.Font=Enum.Font.FredokaOne tLabel.TextSize=14 tLabel.TextXAlignment=Enum.TextXAlignment.Left tLabel.ZIndex=51 tLabel.Parent=frame local bLabel=Instance.new("TextLabel")bLabel.Size=UDim2.new(1,-24,0,20)bLabel.Position=UDim2.new(0,18,0,34)bLabel.BackgroundTransparency=1 bLabel.Text=text or ""bLabel.TextColor3=Color3.fromRGB(205,196,228)bLabel.Font=Enum.Font.Gotham bLabel.TextSize=13 bLabel.TextXAlignment=Enum.TextXAlignment.Left bLabel.ZIndex=51 bLabel.Parent=frame table.insert(activeNotifs,frame)
local prog=Instance.new("Frame")prog.Size=UDim2.new(1,-24,0,2)prog.Position=UDim2.new(0,12,1,-6)prog.BackgroundColor3=C.Pink prog.BorderSizePixel=0 prog.ZIndex=52 prog.Parent=frame round(prog,1)TweenService:Create(prog,TweenInfo.new(duration,Enum.EasingStyle.Linear),{Size=UDim2.new(0,0,0,2)}):Play()
TweenService:Create(frame,TweenInfo.new(0.28,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),{Position=UDim2.new(0,16,1,-y-h)}):Play()task.delay(duration,function()local tw=TweenService:Create(frame,TweenInfo.new(0.22,Enum.EasingStyle.Quad,Enum.EasingDirection.In),{Position=UDim2.new(0,-280,1,-y-h),BackgroundTransparency=1})tw:Play()tw.Completed:Wait()for i,f in ipairs(activeNotifs)do if f==frame then table.remove(activeNotifs,i)break end end frame:Destroy()end)end
local gui=Instance.new("ScreenGui")gui.Name="HardyWare"gui.ResetOnSpawn=false gui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling gui.IgnoreGuiInset=true gui.DisplayOrder=50 gui.Parent=guiParent
local IS_MOBILE=UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
local WIN_W,WIN_H,SIDE_W=780,500,176
if IS_MOBILE then WIN_W,WIN_H,SIDE_W=640,440,150 end
local function tw(o,d,props,style,dir)
	local tween=TweenService:Create(o,TweenInfo.new(d,style or Enum.EasingStyle.Quint,dir or Enum.EasingDirection.Out),props)
	tween:Play()
	return tween
end
local win=Instance.new("Frame")
win.Name="Window"
win.Size=UDim2.new(0,WIN_W,0,WIN_H)
win.AnchorPoint=Vector2.new(0.5,0.5)
win.Position=UDim2.new(0.5,0,0.5,0)
win.BackgroundColor3=Color3.new(1,1,1)
win.BorderSizePixel=0
win.Visible=false
win.Parent=gui
round(win,16)
do
	local g=Instance.new("UIGradient")
	g.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(8,16,42)),ColorSequenceKeypoint.new(1,Color3.fromRGB(3,6,18))})
	g.Rotation=62
	g.Parent=win
	TweenService:Create(g,TweenInfo.new(7,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut,-1,true),{Rotation=118}):Play()
	local st=Instance.new("UIStroke")
	st.Thickness=1.6
	st.Transparency=0.1
	st.ApplyStrokeMode=Enum.ApplyStrokeMode.Border
	st.Color=Color3.new(1,1,1)
	st.Parent=win
	local sg=Instance.new("UIGradient")
	sg.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,C.Pink),ColorSequenceKeypoint.new(0.5,Color3.fromRGB(8,22,60)),ColorSequenceKeypoint.new(1,C.Pink)})
	sg.Parent=st
	TweenService:Create(sg,TweenInfo.new(5,Enum.EasingStyle.Linear,Enum.EasingDirection.In,-1),{Rotation=360}):Play()
end
local uiScaleObj=Instance.new("UIScale")
uiScaleObj.Parent=win
do local old=game:GetService("Lighting"):FindFirstChild("HardyWareBlur")if old then old:Destroy()end end
local blur=Instance.new("BlurEffect")blur.Name="HardyWareBlur"blur.Size=0 blur.Parent=game:GetService("Lighting")
local vpSize=(workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize) or Vector2.new(1280,720)
local isTouchDevice=UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
local baseScale=isTouchDevice and 0.85 or 1
local fitScale=math.min((vpSize.X-24)/WIN_W,(vpSize.Y-24)/WIN_H)
local hubScale=math.max(0.3,math.min(baseScale,fitScale))
uiScaleObj.Scale=hubScale
local hubOpen=false
local veil=Instance.new("Frame")
veil.Name="Veil"
veil.Size=UDim2.new(1,0,1,0)
veil.BackgroundColor3=Color3.new(0,0,0)
veil.BackgroundTransparency=1
veil.BorderSizePixel=0
veil.Active=false
veil.Visible=false
veil.ZIndex=30
veil.Parent=win
round(veil,16)
local sweep=Instance.new("Frame")
sweep.Name="Sweep"
sweep.AnchorPoint=Vector2.new(0.5,0)
sweep.Position=UDim2.new(0.5,0,0,0)
sweep.Size=UDim2.new(0,0,0,2)
sweep.BackgroundColor3=C.Pink
sweep.BackgroundTransparency=1
sweep.BorderSizePixel=0
sweep.ZIndex=31
sweep.Parent=win
local function setHub(open)
	if open==hubOpen then return end
	hubOpen=open
	if open then
		uiScaleObj.Scale=hubScale*0.86
		win.Visible=true
		veil.Visible=true
		veil.BackgroundTransparency=0
		sweep.Size=UDim2.new(0,0,0,2)
		sweep.BackgroundTransparency=0
		tw(uiScaleObj,0.5,{Scale=hubScale},Enum.EasingStyle.Back,Enum.EasingDirection.Out)
		tw(veil,0.45,{BackgroundTransparency=1},Enum.EasingStyle.Quad)
		tw(sweep,0.45,{Size=UDim2.new(1,-32,0,2)},Enum.EasingStyle.Quint)
		tw(blur,0.35,{Size=10})
		task.delay(0.45,function()tw(sweep,0.3,{BackgroundTransparency=1})end)
		task.delay(0.47,function()if hubOpen then veil.Visible=false end end)
	else
		veil.Visible=true
		tw(veil,0.22,{BackgroundTransparency=0},Enum.EasingStyle.Quad,Enum.EasingDirection.In)
		tw(uiScaleObj,0.22,{Scale=hubScale*0.9},Enum.EasingStyle.Quad,Enum.EasingDirection.In)
		tw(blur,0.2,{Size=0})
		task.delay(0.23,function()
			if not hubOpen then
				win.Visible=false
				veil.Visible=false
				uiScaleObj.Scale=hubScale
			end
		end)
	end
end
local function toggleHub()setHub(not hubOpen)end
local function applyScale(v)
	hubScale=math.clamp(v,0.3,1.5)
	if hubOpen then uiScaleObj.Scale=hubScale end
end
local function bindRefit()
	local cam=workspace.CurrentCamera
	if not cam then return end
	cam:GetPropertyChangedSignal("ViewportSize"):Connect(function()
		if State.UserScaled then return end
		local vp=cam.ViewportSize
		local fs=math.min((vp.X-24)/WIN_W,(vp.Y-24)/WIN_H)
		applyScale(math.max(0.3,math.min(baseScale,fs)))
	end)
end
bindRefit()
local isDraggingWindow=false local dragStartMousePos=nil local startWindowPos=nil local topBar=Instance.new("Frame",win)topBar.Size=UDim2.new(1,0,0,34)topBar.BackgroundTransparency=1 topBar.ZIndex=3
topBar.InputBegan:Connect(function(input)if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then isDraggingWindow=true dragStartMousePos=input.Position startWindowPos=win.Position end end)
UserInputService.InputChanged:Connect(function(input)if isDraggingWindow and dragStartMousePos and startWindowPos then if input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch then local delta=(input.Position-dragStartMousePos)/uiScaleObj.Scale win.Position=UDim2.new(startWindowPos.X.Scale,startWindowPos.X.Offset+delta.X,startWindowPos.Y.Scale,startWindowPos.Y.Offset+delta.Y)end end end)
UserInputService.InputEnded:Connect(function(input)if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then isDraggingWindow=false end end)
local sidebar=Instance.new("Frame")
sidebar.Name="Sidebar"
sidebar.Size=UDim2.new(0,0,1,0)
sidebar.BackgroundColor3=C.Header
sidebar.BorderSizePixel=0
sidebar.ZIndex=2
sidebar.Visible=false
sidebar.Parent=win
round(sidebar,16)
local sideCover=Instance.new("Frame")
sideCover.Size=UDim2.new(0,16,1,0)
sideCover.Position=UDim2.new(1,-16,0,0)
sideCover.BackgroundColor3=C.Header
sideCover.BorderSizePixel=0
sideCover.ZIndex=2
sideCover.Parent=sidebar
local sideLine=Instance.new("Frame")
sideLine.Size=UDim2.new(0,1,1,-24)
sideLine.Position=UDim2.new(0,SIDE_W,0,12)
sideLine.BackgroundColor3=C.Border
sideLine.BackgroundTransparency=0.7
sideLine.BorderSizePixel=0
sideLine.ZIndex=3
sideLine.Visible=false
sideLine.Parent=win
-- Container do brand (logo + texto)
local brandFrame=Instance.new("Frame")
brandFrame.Name="BrandFrame"
brandFrame.Size=UDim2.new(0,220,0,36)
brandFrame.AnchorPoint=Vector2.new(0.5,0)
brandFrame.Position=UDim2.new(0.5,0,0,4)
brandFrame.BackgroundTransparency=1
brandFrame.ZIndex=4
brandFrame.Parent=win
-- Logo desenhado: dois circulos + V (igual à imagem)
local logoSize=30
local logo=Instance.new("Frame")
logo.Name="Logo"
logo.Size=UDim2.new(0,logoSize,0,logoSize)
logo.Position=UDim2.new(0,0,0.5,-logoSize/2)
logo.BackgroundTransparency=1
logo.ZIndex=4
logo.Parent=brandFrame
local function mkCirc(parent,cx,cy,r,col)
	local c=Instance.new("Frame")
	c.Size=UDim2.new(0,r*2,0,r*2)
	c.Position=UDim2.new(0,cx-r,0,cy-r)
	c.BackgroundColor3=col
	c.BorderSizePixel=0
	c.ZIndex=5
	c.Parent=parent
	local cc=Instance.new("UICorner")
	cc.CornerRadius=UDim.new(1,0)
	cc.Parent=c
end
local function mkLine(parent,x1,y1,x2,y2,thick,col)
	local dx,dy=x2-x1,y2-y1
	local len=math.sqrt(dx*dx+dy*dy)
	local angle=math.atan2(dy,dx)
	local mx,my=(x1+x2)/2,(y1+y2)/2
	local ln=Instance.new("Frame")
	ln.Size=UDim2.new(0,len,0,thick)
	ln.AnchorPoint=Vector2.new(0.5,0.5)
	ln.Position=UDim2.new(0,mx,0,my)
	ln.BackgroundColor3=col
	ln.BorderSizePixel=0
	ln.Rotation=math.deg(angle)
	ln.ZIndex=5
	ln.Parent=parent
	round(ln,thick/2)
end
local W=Color3.new(1,1,1)
-- circulo pequeno (esquerda)
mkCirc(logo,8,9,3,W)
-- circulo grande (direita)
mkCirc(logo,20,8,6,W)
-- V: duas linhas diagonais
mkLine(logo,3,16,15,27,1.5,W)
mkLine(logo,15,27,27,16,1.5,W)
-- Texto "HardyWare"
local brand=Instance.new("TextLabel")
brand.Name="Brand"
brand.Size=UDim2.new(1,-(logoSize+8),1,0)
brand.Position=UDim2.new(0,logoSize+6,0,0)
brand.BackgroundTransparency=1
brand.Text="HardyWare"
brand.TextColor3=Color3.new(1,1,1)
brand.Font=Enum.Font.GothamBlack
brand.TextSize=20
brand.TextXAlignment=Enum.TextXAlignment.Left
brand.ZIndex=4
brand.Parent=brandFrame
do
	local bg=Instance.new("UIGradient")
	bg.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,C.PinkSoft),ColorSequenceKeypoint.new(0.5,C.Pink),ColorSequenceKeypoint.new(1,C.PinkSoft)})
	bg.Offset=Vector2.new(-0.6,0)
	bg.Parent=brand
	TweenService:Create(bg,TweenInfo.new(2.2,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut,-1,true),{Offset=Vector2.new(0.6,0)}):Play()
end
local TAB_H,TAB_PITCH=32,110
local tabDefs={"PVP","Misc","Soru Macro","Macro","Glitch","Gun","Fps","FFlags","Giant Mode","Blacklist","Hitbox","UI","Stream","Config"}
local tabIndex={}
for i,n in ipairs(tabDefs)do tabIndex[n]=i end
-- abas horizontais no topo da janela, à direita do sidebar
local tabList=Instance.new("ScrollingFrame")
tabList.Name="TabList"
tabList.Size=UDim2.new(1,-16,0,36)
tabList.Position=UDim2.new(0,8,0,44)
tabList.BackgroundTransparency=1
tabList.BorderSizePixel=0
tabList.ScrollBarThickness=0
tabList.ScrollingDirection=Enum.ScrollingDirection.X
tabList.CanvasSize=UDim2.new(0,#tabDefs*TAB_PITCH,0,0)
tabList.ZIndex=3
tabList.Parent=win
local indicator=Instance.new("Frame")
indicator.Size=UDim2.new(0,TAB_H,1,0)
indicator.BackgroundColor3=C.Pink
indicator.BackgroundTransparency=0.72
indicator.BorderSizePixel=0
indicator.ZIndex=3
indicator.Visible=false
indicator.Parent=tabList
round(indicator,8)
do local is=Instance.new("UIStroke")is.Color=C.Pink is.Thickness=1.2 is.Transparency=0.55 is.ApplyStrokeMode=Enum.ApplyStrokeMode.Border is.Parent=indicator end
local indBar=Instance.new("Frame")
indBar.Size=UDim2.new(0,16,0,3)
indBar.AnchorPoint=Vector2.new(0.5,1)
indBar.Position=UDim2.new(0.5,0,1,0)
indBar.BackgroundColor3=C.Pink
indBar.BorderSizePixel=0
indBar.ZIndex=4
indBar.Parent=indicator
round(indBar,2)
local footer=Instance.new("TextLabel")
footer.Size=UDim2.new(1,-20,0,28)
footer.Position=UDim2.new(0,14,1,-34)
footer.BackgroundTransparency=1
footer.Text=IS_MOBILE and "Toque na bolinha pra abrir/fechar" or "LeftCtrl / F2 abre e fecha"
footer.TextColor3=C.Muted
footer.Font=Enum.Font.Gotham
footer.TextSize=10
footer.TextWrapped=true
footer.TextXAlignment=Enum.TextXAlignment.Left
footer.TextYAlignment=Enum.TextYAlignment.Bottom
footer.ZIndex=4
footer.Parent=sidebar
-- pageTitle removido: o nome já aparece na própria aba selecionada
local pageTitle={Text=""}-- stub vazio para não quebrar refs a pageTitle.Text
local headLine=Instance.new("Frame")
headLine.Size=UDim2.new(1,-16,0,1)
headLine.Position=UDim2.new(0,8,0,42)
headLine.BackgroundColor3=C.Border
headLine.BackgroundTransparency=0.75
headLine.BorderSizePixel=0
headLine.ZIndex=3
headLine.Parent=win
-- linha separadora sob as abas
local tabLine=Instance.new("Frame")
tabLine.Size=UDim2.new(1,-16,0,1)
tabLine.Position=UDim2.new(0,8,0,82)
tabLine.BackgroundColor3=C.Border
tabLine.BackgroundTransparency=0.6
tabLine.BorderSizePixel=0
tabLine.ZIndex=3
tabLine.Parent=win
local closeBtn=Instance.new("TextButton")
closeBtn.Size=UDim2.new(0,28,0,28)
closeBtn.Position=UDim2.new(1,-38,0,8)
closeBtn.BackgroundColor3=C.Red
closeBtn.BackgroundTransparency=1
closeBtn.Text="X"
closeBtn.TextColor3=C.Muted
closeBtn.Font=Enum.Font.GothamBold
closeBtn.TextSize=13
closeBtn.AutoButtonColor=false
closeBtn.ZIndex=6
closeBtn.Parent=win
round(closeBtn,8)
closeBtn.MouseEnter:Connect(function()tw(closeBtn,0.12,{BackgroundTransparency=0.7,TextColor3=C.White})end)
closeBtn.MouseLeave:Connect(function()tw(closeBtn,0.12,{BackgroundTransparency=1,TextColor3=C.Muted})end)
closeBtn.MouseButton1Click:Connect(function()setHub(false)end)
local pageHolder=Instance.new("Frame")
pageHolder.Name="Pages"
pageHolder.Size=UDim2.new(1,-16,1,-96)
pageHolder.Position=UDim2.new(0,8,0,88)
pageHolder.BackgroundTransparency=1
pageHolder.ClipsDescendants=true
pageHolder.ZIndex=2
pageHolder.Parent=win
local ToggleButton=Instance.new("TextButton")
ToggleButton.Name="FloatingToggle"
ToggleButton.Size=isTouchDevice and UDim2.new(0,44,0,44) or UDim2.new(0,52,0,52)
ToggleButton.Position=UDim2.new(0,20,0.5,-22)
ToggleButton.BackgroundColor3=C.Surface
ToggleButton.BackgroundTransparency=0
ToggleButton.Text=""-- sem letra; logo desenhado abaixo
line(ToggleButton,C.Border,2.4,0.05)
ToggleButton.AutoButtonColor=false
ToggleButton.Active=true
ToggleButton.Parent=gui
ToggleButton.Visible=true
round(ToggleButton,26)
-- Logo no botão flutuante: mesma composição do topbar (2 círculos + V)
do
	local sz=isTouchDevice and 44 or 52
	local S=sz*0.58-- area do logo dentro do botao
	local ox=(sz-S)/2 local oy=(sz-S)/2
	local W2=C.Pink
	local function tbCirc(cx,cy,r)
		local c=Instance.new("Frame")
		c.Size=UDim2.new(0,r*2,0,r*2)
		c.Position=UDim2.new(0,ox+cx*S/30-r,0,oy+cy*S/30-r)
		c.BackgroundColor3=W2 c.BorderSizePixel=0 c.ZIndex=6 c.Parent=ToggleButton
		local cc=Instance.new("UICorner") cc.CornerRadius=UDim.new(1,0) cc.Parent=c
	end
	local function tbLine(x1,y1,x2,y2,th)
		local dx,dy=x2-x1,y2-y1
		local len=math.sqrt(dx*dx+dy*dy)*(S/30)
		local angle=math.atan2(dy,dx)
		local mx=(ox+(x1+x2)/2*S/30) local my=(oy+(y1+y2)/2*S/30)
		local ln=Instance.new("Frame")
		ln.Size=UDim2.new(0,len,0,th)
		ln.AnchorPoint=Vector2.new(0.5,0.5)
		ln.Position=UDim2.new(0,mx,0,my)
		ln.BackgroundColor3=W2 ln.BorderSizePixel=0 ln.Rotation=math.deg(angle) ln.ZIndex=6 ln.Parent=ToggleButton
		round(ln,th/2)
	end
	tbCirc(8,9,3*(S/30))-- ponto pequeno esquerda
	tbCirc(20,8,6*(S/30))-- circulo grande direita
	tbLine(3,16,15,27,1.5)-- V esquerda
	tbLine(15,27,27,16,1.5)-- V direita
end
local draggingBtn=false local dragStartMouse,dragStartPos
ToggleButton.InputBegan:Connect(function(input,gp)if gp then return end if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then draggingBtn=true dragStartMouse=Vector2.new(input.Position.X,input.Position.Y)dragStartPos=ToggleButton.Position end end)
UserInputService.InputChanged:Connect(function(input)if draggingBtn and(input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch)then local delta=Vector2.new(input.Position.X,input.Position.Y)-dragStartMouse local ss=gui.AbsoluteSize local nX=math.clamp(dragStartPos.X.Scale+delta.X/ss.X,0,1-ToggleButton.Size.X.Scale)local nY=math.clamp(dragStartPos.Y.Scale+delta.Y/ss.Y,0,1-ToggleButton.Size.Y.Scale)ToggleButton.Position=UDim2.new(nX,0,nY,0)end end)
UserInputService.InputEnded:Connect(function(input)if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then if draggingBtn then draggingBtn=false if dragStartMouse and(Vector2.new(input.Position.X,input.Position.Y)-dragStartMouse).Magnitude<10 then toggleHub()end end end end)
local MobileJump={enabled=false,dragging=false,dragStartMouse=nil,dragStartPos=nil,btn=nil,}
local mobileJumpBtn=Instance.new("TextButton")mobileJumpBtn.Name="MobileJumpBtn"mobileJumpBtn.Size=UDim2.new(0,64,0,64)mobileJumpBtn.Position=UDim2.new(0.85,0,0.6,0)mobileJumpBtn.BackgroundColor3=Color3.fromRGB(14,14,18)mobileJumpBtn.BackgroundTransparency=0.2 mobileJumpBtn.Text="G"mobileJumpBtn.TextColor3=C.Pink mobileJumpBtn.Font=Enum.Font.FredokaOne mobileJumpBtn.TextSize=24 mobileJumpBtn.AutoButtonColor=false mobileJumpBtn.Active=true mobileJumpBtn.Parent=gui mobileJumpBtn.Visible=false round(mobileJumpBtn,32)line(mobileJumpBtn,C.PinkSoft,2,0.2)MobileJump.btn=mobileJumpBtn
local function doMobileJump()local char=player.Character local hrp=char and char:FindFirstChild("HumanoidRootPart")local hum=char and char:FindFirstChildOfClass("Humanoid")if hrp and hum and hum.Health>0 then local force=State.JumpForce or 300 local currentVel=hrp.AssemblyLinearVelocity hrp.AssemblyLinearVelocity=Vector3.new(currentVel.X,force,currentVel.Z)if hum:GetState()~=Enum.HumanoidStateType.Freefall then hum:ChangeState(Enum.HumanoidStateType.Jumping)end TweenService:Create(mobileJumpBtn,TweenInfo.new(0.08),{BackgroundColor3=C.Pink,TextColor3=C.Bg}):Play()task.delay(0.15,function()if mobileJumpBtn and mobileJumpBtn.Parent then TweenService:Create(mobileJumpBtn,TweenInfo.new(0.15),{BackgroundColor3=Color3.fromRGB(14,14,18),TextColor3=C.Pink}):Play()end end)end end
mobileJumpBtn.InputBegan:Connect(function(input,gp)if gp then return end if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then MobileJump.dragging=true MobileJump.dragStartMouse=Vector2.new(input.Position.X,input.Position.Y)MobileJump.dragStartPos=mobileJumpBtn.Position end end)
UserInputService.InputChanged:Connect(function(input)if MobileJump.dragging and(input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch)then local delta=Vector2.new(input.Position.X,input.Position.Y)-MobileJump.dragStartMouse local ss=gui.AbsoluteSize local nX=math.clamp(MobileJump.dragStartPos.X.Scale+delta.X/ss.X,0,1-mobileJumpBtn.Size.X.Scale)local nY=math.clamp(MobileJump.dragStartPos.Y.Scale+delta.Y/ss.Y,0,1-mobileJumpBtn.Size.Y.Scale)mobileJumpBtn.Position=UDim2.new(nX,0,nY,0)end end)
UserInputService.InputEnded:Connect(function(input)if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then if MobileJump.dragging then MobileJump.dragging=false local moved=MobileJump.dragStartMouse and(Vector2.new(input.Position.X,input.Position.Y)-MobileJump.dragStartMouse).Magnitude or 0 if moved<10 then doMobileJump()end end end end)
_G.MobileJump={SetEnabled=function(v,silent)MobileJump.enabled=v mobileJumpBtn.Visible=v if not silent then notify(t("notif_title"),"Jump Mobile "..(v and t("enabled")or t("disabled")),1.6)end end,IsEnabled=function()return MobileJump.enabled end,Jump=doMobileJump,}
local SaveRegistry={toggles={},sliders={},dropdowns={},inputs={}}
local _saveCounter=0
local function nextSaveId(prefix)_saveCounter=_saveCounter+1 return prefix.."_".._saveCounter end
local function reg(obj,key,prop,suffix)table.insert(TransRegistry,{obj=obj,key=key,prop=prop or "Text",suffix=suffix or ""})end
local function rowStyle(row)
	round(row,8)
	local s=Instance.new("UIStroke")
	s.Color=C.Border
	s.Thickness=1
	s.Transparency=0.8
	s.ApplyStrokeMode=Enum.ApplyStrokeMode.Border
	s.Parent=row
	return s
end
local function newLabel(parent,text,size,pos,font,ts,color)
	local l=Instance.new("TextLabel")
	l.Size=size
	l.Position=pos
	l.BackgroundTransparency=1
	l.Text=text
	l.TextColor3=color
	l.Font=font
	l.TextSize=ts
	l.TextXAlignment=Enum.TextXAlignment.Left
	l.TextTruncate=Enum.TextTruncate.AtEnd
	l.ZIndex=4
	l.Parent=parent
	return l
end
local function title(p,keyText,suffix)
	local holder=Instance.new("Frame")
	holder.Size=UDim2.new(1,0,0,24)
	holder.BackgroundTransparency=1
	holder.Parent=p
	local bar=Instance.new("Frame")
	bar.Size=UDim2.new(0,3,0,12)
	bar.AnchorPoint=Vector2.new(0,0.5)
	bar.Position=UDim2.new(0,2,0.5,0)
	bar.BackgroundColor3=C.Pink
	bar.BorderSizePixel=0
	bar.ZIndex=3
	bar.Parent=holder
	round(bar,2)
	local l=newLabel(holder,"",UDim2.new(1,-14,1,0),UDim2.new(0,12,0,0),Enum.Font.GothamBold,12,C.PinkSoft)
	if keyText then
		l.Text=t(keyText)..(suffix or "")
		reg(l,keyText,"Text",suffix)
	end
	return l
end
local BindKeys={}
local BindFire={}
local Listening=nil
BindKeys["fly_enabled"]=Enum.KeyCode.H
local function ListenBind(id,btn)Listening={id=id,btn=btn}btn.Text="..."end
UserInputService.InputBegan:Connect(function(input,gp)if input.UserInputType~=Enum.UserInputType.Keyboard then return end if Listening then local L=Listening Listening=nil if input.KeyCode==Enum.KeyCode.Escape then BindKeys[L.id]=nil else BindKeys[L.id]=input.KeyCode end L.btn.Text=BindKeys[L.id] and BindKeys[L.id].Name or "-" return end if gp or UserInputService:GetFocusedTextBox() then return end for id,kc in pairs(BindKeys)do if kc==input.KeyCode and BindFire[id] then BindFire[id]() end end end)
local activeDrag=nil
UserInputService.InputChanged:Connect(function(input)
	if activeDrag and(input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch)then
		activeDrag.move(input.Position.X)
	end
end)
UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
		if activeDrag then
			local d=activeDrag
			activeDrag=nil
			d.finish()
		end
	end
end)
local function toggle(p,keyText,key,initial,callback,showNotification,bindable)
	if showNotification==nil then showNotification=true end
	local on=initial or false
	local row=Instance.new("TextButton")
	row.Size=UDim2.new(1,0,0,32)
	row.BackgroundColor3=C.Surface
	row.BackgroundTransparency=0.45
	row.BorderSizePixel=0
	row.Text=""
	row.AutoButtonColor=false
	row.ClipsDescendants=true
	row.ZIndex=3
	row.Parent=p
	local rowStroke=rowStyle(row)
	rowStroke.Transparency=on and 0.4 or 0.8
	local hasKey=(key or bindable)and true or false
	local lab=newLabel(row,t(keyText),UDim2.new(1,hasKey and -126 or -66,1,0),UDim2.new(0,12,0,0),Enum.Font.GothamMedium,12,on and C.White or C.Gray)
	reg(lab,keyText)
	local track=Instance.new("Frame")
	track.Size=UDim2.new(0,38,0,20)
	track.AnchorPoint=Vector2.new(1,0.5)
	track.Position=UDim2.new(1,-10,0.5,0)
	track.BackgroundColor3=on and C.Pink or C.Track
	track.BorderSizePixel=0
	track.ZIndex=4
	track.Parent=row
	round(track,10)
	local glow=Instance.new("UIStroke")
	glow.Color=C.PinkSoft glow.Thickness=2 glow.Transparency=on and 0.55 or 1
	glow.ApplyStrokeMode=Enum.ApplyStrokeMode.Border glow.Parent=track
	local knob=Instance.new("Frame")
	knob.Size=UDim2.new(0,14,0,14)
	knob.AnchorPoint=Vector2.new(0,0.5)
	knob.Position=on and UDim2.new(1,-17,0.5,0) or UDim2.new(0,3,0.5,0)
	knob.BackgroundColor3=Color3.new(1,1,1)
	knob.BorderSizePixel=0
	knob.ZIndex=5
	knob.Parent=track
	round(knob,7)
	if key or bindable then
		local k=Instance.new("TextButton")
		k.Size=UDim2.new(0,52,0,20)
		k.AnchorPoint=Vector2.new(1,0.5)
		k.Position=UDim2.new(1,-56,0.5,0)
		k.BackgroundColor3=C.Bg
		k.BackgroundTransparency=0.35
		k.BorderSizePixel=0
		k.AutoButtonColor=false
		k.TextColor3=C.Muted
		k.Font=Enum.Font.Gotham
		k.TextSize=10
		k.TextTruncate=Enum.TextTruncate.AtEnd
		k.ZIndex=5
		k.Parent=row
		round(k,5)
		k.Text=bindable and(BindKeys[keyText]and BindKeys[keyText].Name or "-")or key
		if bindable then k.MouseButton1Click:Connect(function()ListenBind(keyText,k)end)end
	end
	row.MouseEnter:Connect(function()tw(row,0.14,{BackgroundTransparency=0.25})tw(lab,0.16,{Position=UDim2.new(0,16,0,0)})end)
	row.MouseLeave:Connect(function()tw(row,0.14,{BackgroundTransparency=0.45})tw(lab,0.16,{Position=UDim2.new(0,12,0,0)})end)
	row.MouseButton1Down:Connect(function(x,y)
		tw(knob,0.1,{Size=UDim2.new(0,19,0,14)})
		rowStroke.Transparency=0.05
		tw(rowStroke,0.4,{Transparency=on and 0.4 or 0.8})
		local rel=(Vector2.new(x,y)-row.AbsolutePosition)/uiScaleObj.Scale
		local rip=Instance.new("Frame")
		rip.AnchorPoint=Vector2.new(0.5,0.5)
		rip.Position=UDim2.new(0,rel.X,0,rel.Y)
		rip.Size=UDim2.new(0,0,0,0)
		rip.BackgroundColor3=C.Pink
		rip.BackgroundTransparency=0.55
		rip.BorderSizePixel=0
		rip.ZIndex=3
		rip.Parent=row
		local rc=Instance.new("UICorner")rc.CornerRadius=UDim.new(1,0)rc.Parent=rip
		tw(rip,0.5,{Size=UDim2.new(0,240,0,240),BackgroundTransparency=1})
		Debris:AddItem(rip,0.55)
	end)
	local function setOn(v)
		on=v and true or false
		tw(track,0.2,{BackgroundColor3=on and C.Pink or C.Track})
		tw(knob,0.28,{Size=UDim2.new(0,14,0,14),Position=on and UDim2.new(1,-17,0.5,0) or UDim2.new(0,3,0.5,0)},Enum.EasingStyle.Back)
		tw(lab,0.18,{TextColor3=on and C.White or C.Gray})
		tw(rowStroke,0.18,{Transparency=on and 0.4 or 0.8})
		tw(glow,0.25,{Transparency=on and 0.55 or 1})
	end
	local function fire()
		local nextState=not on
		setOn(nextState)
		if callback then callback(nextState)end
		if showNotification then notify(t("notif_title"),t(keyText).." "..(nextState and t("enabled")or t("disabled")),1.6)end
	end
	row.MouseButton1Click:Connect(fire)
	if bindable then BindFire[keyText]=fire end
	local api={Set=setOn,Get=function()return on end,Fire=fire}
	local saveId=nextSaveId("t")
	SaveRegistry.toggles[saveId]={name=keyText,get=function()return api.Get()end,set=function(v)setOn(v)if callback then callback(v)end end,}
	return api
end
local function slider(p,keyText,cur,minV,maxV,callback)
	local row=Instance.new("Frame")
	row.Size=UDim2.new(1,0,0,48)
	row.BackgroundColor3=C.Surface
	row.BackgroundTransparency=0.45
	row.BorderSizePixel=0
	row.ZIndex=3
	row.Parent=p
	rowStyle(row)
	local lab=newLabel(row,t(keyText),UDim2.new(1,-100,0,18),UDim2.new(0,12,0,7),Enum.Font.GothamMedium,12,C.White)
	reg(lab,keyText)
	local val=newLabel(row,"",UDim2.new(0,80,0,18),UDim2.new(1,-92,0,7),Enum.Font.GothamBold,11,C.Pink)
	val.TextXAlignment=Enum.TextXAlignment.Right
	local track=Instance.new("Frame")
	track.Size=UDim2.new(1,-24,0,6)
	track.Position=UDim2.new(0,12,0,34)
	track.BackgroundColor3=C.Track
	track.BorderSizePixel=0
	track.ZIndex=4
	track.Parent=row
	round(track,3)
	local fill=Instance.new("Frame")
	fill.Size=UDim2.new(0,0,1,0)
	fill.BackgroundColor3=C.Pink
	fill.BorderSizePixel=0
	fill.ZIndex=5
	fill.Parent=track
	round(fill,3)
	local knob=Instance.new("Frame")
	knob.Size=UDim2.new(0,12,0,12)
	knob.AnchorPoint=Vector2.new(0.5,0.5)
	knob.Position=UDim2.new(0,0,0.5,0)
	knob.BackgroundColor3=Color3.new(1,1,1)
	knob.BorderSizePixel=0
	knob.ZIndex=6
	knob.Parent=track
	round(knob,6)
	local hit=Instance.new("TextButton")
	hit.Size=UDim2.new(1,-12,0,26)
	hit.Position=UDim2.new(0,6,0,22)
	hit.BackgroundTransparency=1
	hit.Text=""
	hit.AutoButtonColor=false
	hit.ZIndex=7
	hit.Parent=row
	local currentValue=cur
	local first=true
	local function visual(v)
		local pct=0
		if maxV>minV then pct=math.clamp((v-minV)/(maxV-minV),0,1)end
		if first then
			fill.Size=UDim2.new(pct,0,1,0)
			knob.Position=UDim2.new(pct,0,0.5,0)
			first=false
		else
			tw(fill,0.09,{Size=UDim2.new(pct,0,1,0)})
			tw(knob,0.09,{Position=UDim2.new(pct,0,0.5,0)})
		end
		val.Text=string.format("%.2f",v)
	end
	visual(cur)
	local function updateFromX(x)
		local sw=track.AbsoluteSize.X
		if sw<=0 then return end
		local percent=math.clamp((x-track.AbsolutePosition.X)/sw,0,1)
		local v=minV+percent*(maxV-minV)
		currentValue=v
		visual(v)
		if callback then callback(v)end
	end
	hit.InputBegan:Connect(function(input)
		if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
			tw(knob,0.1,{Size=UDim2.new(0,16,0,16)})
			activeDrag={move=updateFromX,finish=function()tw(knob,0.12,{Size=UDim2.new(0,12,0,12)})end}
			updateFromX(input.Position.X)
		end
	end)
	row.MouseEnter:Connect(function()tw(row,0.12,{BackgroundTransparency=0.25})end)
	row.MouseLeave:Connect(function()tw(row,0.12,{BackgroundTransparency=0.45})end)
	local api={Set=function(v)currentValue=v visual(v)end}
	local saveId=nextSaveId("s")
	SaveRegistry.sliders[saveId]={name=keyText,get=function()return currentValue end,set=function(v)currentValue=v visual(v)if callback then callback(v)end end,}
	return api
end
local function dropdown(p,keyText,values,initial,callback)
	local idx=1
	for i,v in ipairs(values)do if v==initial then idx=i break end end
	local HEAD,OPT=32,24
	local open=false
	local holder=Instance.new("Frame")
	holder.Size=UDim2.new(1,0,0,HEAD)
	holder.BackgroundColor3=C.Surface
	holder.BackgroundTransparency=0.45
	holder.BorderSizePixel=0
	holder.ClipsDescendants=true
	holder.ZIndex=3
	holder.Parent=p
	local hs=rowStyle(holder)
	local head=Instance.new("TextButton")
	head.Size=UDim2.new(1,0,0,HEAD)
	head.BackgroundTransparency=1
	head.Text=""
	head.AutoButtonColor=false
	head.ZIndex=4
	head.Parent=holder
	local lab=newLabel(head,t(keyText),UDim2.new(0.5,-12,1,0),UDim2.new(0,12,0,0),Enum.Font.GothamMedium,12,C.Gray)
	reg(lab,keyText)
	local valLbl=newLabel(head,tostring(values[idx]),UDim2.new(0.5,-34,1,0),UDim2.new(0.5,0,0,0),Enum.Font.Gotham,11,C.PinkSoft)
	valLbl.TextXAlignment=Enum.TextXAlignment.Right
	local arrow=Instance.new("TextLabel")
	arrow.Size=UDim2.new(0,16,0,16)
	arrow.AnchorPoint=Vector2.new(1,0.5)
	arrow.Position=UDim2.new(1,-10,0.5,0)
	arrow.BackgroundTransparency=1
	arrow.Text=">"
	arrow.TextColor3=C.Muted
	arrow.Font=Enum.Font.GothamBold
	arrow.TextSize=12
	arrow.ZIndex=5
	arrow.Parent=head
	local list=Instance.new("Frame")
	list.Size=UDim2.new(1,0,0,#values*OPT)
	list.Position=UDim2.new(0,0,0,HEAD)
	list.BackgroundTransparency=1
	list.ZIndex=4
	list.Parent=holder
	local ll=Instance.new("UIListLayout")
	ll.SortOrder=Enum.SortOrder.LayoutOrder
	ll.Parent=list
	local optButtons={}
	local function paintOptions()
		for i,b in ipairs(optButtons)do
			b.TextColor3=(i==idx)and C.Pink or C.Gray
			b.Font=(i==idx)and Enum.Font.GothamBold or Enum.Font.GothamMedium
		end
	end
	local function setOpen(v)
		open=v
		tw(holder,0.22,{Size=UDim2.new(1,0,0,HEAD+(open and(#values*OPT+4)or 0))})
		tw(arrow,0.22,{Rotation=open and 90 or 0})
		tw(hs,0.2,{Transparency=open and 0.45 or 0.8})
	end
	for i,v in ipairs(values)do
		local b=Instance.new("TextButton")
		b.Size=UDim2.new(1,0,0,OPT)
		b.LayoutOrder=i
		b.BackgroundColor3=C.Pink
		b.BackgroundTransparency=1
		b.BorderSizePixel=0
		b.Text=tostring(v)
		b.TextXAlignment=Enum.TextXAlignment.Left
		b.Font=Enum.Font.GothamMedium
		b.TextSize=11
		b.AutoButtonColor=false
		b.ZIndex=5
		b.Parent=list
		local pad=Instance.new("UIPadding")
		pad.PaddingLeft=UDim.new(0,14)
		pad.Parent=b
		b.MouseEnter:Connect(function()tw(b,0.1,{BackgroundTransparency=0.85})end)
		b.MouseLeave:Connect(function()tw(b,0.1,{BackgroundTransparency=1})end)
		b.MouseButton1Click:Connect(function()
			idx=i
			valLbl.Text=tostring(values[idx])
			paintOptions()
			setOpen(false)
			if callback then callback(values[idx])end
		end)
		optButtons[i]=b
	end
	paintOptions()
	head.MouseButton1Click:Connect(function()setOpen(not open)end)
	head.MouseEnter:Connect(function()if not open then tw(holder,0.12,{BackgroundTransparency=0.25})end end)
	head.MouseLeave:Connect(function()tw(holder,0.12,{BackgroundTransparency=0.45})end)
	local function applyValue(v)
		for i,val in ipairs(values)do if val==v then idx=i break end end
		valLbl.Text=tostring(values[idx])
		paintOptions()
	end
	local api={Set=applyValue}
	local saveId=nextSaveId("d")
	SaveRegistry.dropdowns[saveId]={name=keyText,get=function()return values[idx]end,set=function(v)applyValue(v)if callback then callback(values[idx])end end,}
	return api
end
local function inputField(p,keyText,defaultVal,callback)
	local row=Instance.new("Frame")
	row.Size=UDim2.new(1,0,0,32)
	row.BackgroundColor3=C.Surface
	row.BackgroundTransparency=0.45
	row.BorderSizePixel=0
	row.ZIndex=3
	row.Parent=p
	rowStyle(row)
	local lab=newLabel(row,t(keyText),UDim2.new(0.5,-12,1,0),UDim2.new(0,12,0,0),Enum.Font.GothamMedium,12,C.Gray)
	reg(lab,keyText)
	local box=Instance.new("Frame")
	box.Size=UDim2.new(0,100,0,22)
	box.AnchorPoint=Vector2.new(1,0.5)
	box.Position=UDim2.new(1,-8,0.5,0)
	box.BackgroundColor3=C.Bg
	box.BackgroundTransparency=0.2
	box.BorderSizePixel=0
	box.ZIndex=4
	box.Parent=row
	round(box,6)
	local boxStroke=Instance.new("UIStroke")
	boxStroke.Color=C.Border
	boxStroke.Thickness=1
	boxStroke.Transparency=0.65
	boxStroke.ApplyStrokeMode=Enum.ApplyStrokeMode.Border
	boxStroke.Parent=box
	local tb=Instance.new("TextBox")
	tb.Size=UDim2.new(1,-12,1,0)
	tb.Position=UDim2.new(0,6,0,0)
	tb.BackgroundTransparency=1
	tb.Text=tostring(defaultVal)
	tb.TextColor3=C.White
	tb.Font=Enum.Font.Gotham
	tb.TextSize=11
	tb.TextXAlignment=Enum.TextXAlignment.Center
	tb.ClearTextOnFocus=false
	tb.ZIndex=5
	tb.Parent=box
	tb.Focused:Connect(function()tw(boxStroke,0.15,{Transparency=0.05})end)
	tb.FocusLost:Connect(function()
		tw(boxStroke,0.15,{Transparency=0.65})
		local v=tonumber(tb.Text)
		if v and callback then callback(v)end
	end)
	row.MouseEnter:Connect(function()tw(row,0.12,{BackgroundTransparency=0.25})end)
	row.MouseLeave:Connect(function()tw(row,0.12,{BackgroundTransparency=0.45})end)
	local saveId=nextSaveId("i")
	SaveRegistry.inputs[saveId]={name=keyText,get=function()return tb.Text end,set=function(v)tb.Text=tostring(v)local n=tonumber(v)if n and callback then callback(n)end end,}
	return tb
end
local pages={}
local function wireOrder(f)
	local n=0
	f.ChildAdded:Connect(function(c)
		if c:IsA("GuiObject")then
			n=n+1
			c.LayoutOrder=n
		end
	end)
end
local function createPage(name)
	local group=Instance.new("CanvasGroup")
	group.Name=name
	group.Size=UDim2.new(1,0,1,0)
	group.BackgroundTransparency=1
	group.GroupTransparency=1
	group.Visible=false
	group.Parent=pageHolder
	local scroll=Instance.new("ScrollingFrame")
	scroll.Size=UDim2.new(1,0,1,0)
	scroll.BackgroundTransparency=1
	scroll.BorderSizePixel=0
	scroll.ScrollBarThickness=3
	scroll.ScrollBarImageColor3=C.Pink
	scroll.CanvasSize=UDim2.new(0,0,0,0)
	scroll.AutomaticCanvasSize=Enum.AutomaticSize.Y
	scroll.ScrollingDirection=Enum.ScrollingDirection.Y
	scroll.Parent=group
	local sl=Instance.new("UIListLayout")
	sl.SortOrder=Enum.SortOrder.LayoutOrder
	sl.Parent=scroll
	local pad=Instance.new("UIPadding")
	pad.PaddingRight=UDim.new(0,6)
	pad.PaddingBottom=UDim.new(0,8)
	pad.Parent=scroll
	local cols=Instance.new("Frame")
	cols.Size=UDim2.new(1,0,0,0)
	cols.AutomaticSize=Enum.AutomaticSize.Y
	cols.BackgroundTransparency=1
	cols.Parent=scroll
	local function column(xScale,xOff)
		local f=Instance.new("Frame")
		f.Size=UDim2.new(0.5,-6,0,0)
		f.Position=UDim2.new(xScale,xOff,0,0)
		f.AutomaticSize=Enum.AutomaticSize.Y
		f.BackgroundTransparency=1
		f.Parent=cols
		local l=Instance.new("UIListLayout")
		l.Padding=UDim.new(0,6)
		l.SortOrder=Enum.SortOrder.LayoutOrder
		l.Parent=f
		wireOrder(f)
		return f
	end
	local left=column(0,0)
	local right=column(0.5,6)
	pages[name]={page=group,scroll=scroll,left=left,right=right}
	return pages[name]
end
local function updateCanvas(col)end
local function refreshAllPages()end
for _,n in ipairs(tabDefs)do createPage(n)end
_G.__HardyWareTabTrans={}
local tabLabels={}
local currentPage=nil
local function paintTab(name,hover)
	local lbl=tabLabels[name]
	if not lbl then return end
	local active=(name==currentPage)
	local btn=tabList:FindFirstChild(name)
	if btn then
		if active then
			tw(btn,0.16,{BackgroundTransparency=0.35,BackgroundColor3=C.Pink})
		elseif hover then
			tw(btn,0.12,{BackgroundTransparency=0.75,BackgroundColor3=C.Surface})
		else
			tw(btn,0.12,{BackgroundTransparency=1})
		end
	end
	tw(lbl,0.16,{TextColor3=active and C.White or(hover and C.Gray or C.Muted)})
end
local function showPage(name)
	local data=pages[name]
	if not data or currentPage==name then return end
	local prevName=currentPage
	currentPage=name
	if prevName and pages[prevName]then
		local pg=pages[prevName].page
		tw(pg,0.12,{GroupTransparency=1},Enum.EasingStyle.Quad)
		task.delay(0.13,function()if currentPage~=prevName then pg.Visible=false end end)
		paintTab(prevName,false)
	end
	paintTab(name,false)
	local x=(tabIndex[name]-1)*TAB_PITCH
	if indicator.Visible then
		tw(indicator,0.38,{Position=UDim2.new(0,x,0,0)},Enum.EasingStyle.Back)
	else
		indicator.Position=UDim2.new(0,x,0,0)
		indicator.Visible=true
	end
	data.page.Position=UDim2.new(0,0,0,0)
	data.page.GroupTransparency=1
	data.page.Visible=true
	tw(data.page,0.3,{GroupTransparency=0})
	data.left.Position=UDim2.new(0,0,0,16)
	data.right.Position=UDim2.new(0.5,6,0,28)
	tw(data.left,0.4,{Position=UDim2.new(0,0,0,0)},Enum.EasingStyle.Back)
	task.delay(0.06,function()tw(data.right,0.4,{Position=UDim2.new(0.5,6,0,0)},Enum.EasingStyle.Back)end)
	pageTitle.Text=name
	pageTitle.TextTransparency=1
	tw(pageTitle,0.3,{TextTransparency=0})
end
for i,n in ipairs(tabDefs)do
	local btn=Instance.new("TextButton")
	btn.Name=n
	btn.Size=UDim2.new(0,TAB_PITCH,1,0)
	btn.Position=UDim2.new(0,(i-1)*TAB_PITCH,0,0)
	btn.BackgroundColor3=C.Surface
	btn.BackgroundTransparency=1
	btn.BorderSizePixel=0
	btn.Text=""
	btn.AutoButtonColor=false
	btn.ZIndex=5
	btn.Parent=tabList
	round(btn,6)
	local lbl=Instance.new("TextLabel")
	lbl.Size=UDim2.new(1,0,1,0)
	lbl.Position=UDim2.new(0,0,0,0)
	lbl.BackgroundTransparency=1
	lbl.Text=n
	lbl.TextColor3=C.Muted
	lbl.Font=Enum.Font.GothamMedium
	lbl.TextSize=11
	lbl.TextXAlignment=Enum.TextXAlignment.Center
	lbl.TextWrapped=true
	lbl.ZIndex=6
	lbl.Parent=btn
	tabLabels[n]=lbl
	_G.__HardyWareTabTrans[n]=lbl
	btn.MouseEnter:Connect(function()paintTab(n,true)end)
	btn.MouseLeave:Connect(function()paintTab(n,false)end)
	btn.MouseButton1Click:Connect(function()showPage(n)end)
end
local targetLockToggle
do local ok,err=pcall(function()
local p=pages["PVP"] local L,R=p.left,p.right
local SA=SilentAimModule
title(L,"Silent Aim")
toggle(L,"Aimbot Player (silent)",nil,false,function(on)SA:SetPlayerSilentAim(on)end,true,true)
toggle(L,"Aimbot NPC (silent)",nil,false,function(on)SA:SetNPCSilentAim(on)end,true,true)
dropdown(L,"Silent Part",{"HumanoidRootPart","Head","UpperTorso"},"HumanoidRootPart",function(v)SA:SetSilentPart(v)end)
toggle(L,"Prediction",nil,true,function(on)SA:SetPrediction(on)end,true,true)
slider(L,"Prediction Amount",0.12,0,0.30,function(v)SA:SetPredictionAmount(v)end)
toggle(L,"Sticky Target",nil,true,function(on)SA:SetSilentSticky(on)end,true,true)
title(L,"Silent TP")
toggle(L,"Silent TP (TP + Silent)",nil,false,function(on)SA:SetSilentTP(on)end,true,true)
slider(L,"TP Dist (studs)",999,10,999,function(v)SA:SetSilentTPDist(math.floor(v))end)
title(L,"Aimbot")
toggle(L,"Skill Aimbot",nil,false,function(on)SA:SetSkillAimbot(on)end,true,true)
toggle(L,"Skill Silent",nil,true,function(on)SA:SetSkillSilent(on)end,true,true)
toggle(L,"Skill CamLock",nil,false,function(on)SA:SetSkillCamLock(on)end,true,true)
dropdown(L,"Skill Range",{"100","250","500","750","1000","1500","2000"},"1000",function(v)SA:SetSkillAimbotDist(tonumber(v) or 1000)end)
dropdown(L,"Target Switch",{"0s","0.03s","0.05s","0.10s","0.20s"},"0s",function(v)local n=tonumber(v:match("[%d%.]+"))or 0 SA:SetTargetSwitchDelay(n)end)
toggle(L,"Tracers",nil,false,function(on)SA:SetTracerEnabled(on)end,true,true)
toggle(L,"CamLock",nil,false,function(on)SA:SetPermanentCamLock(on)end,true,true)
dropdown(L,"Lock Part",{"Head","HumanoidRootPart","UpperTorso"},"Head",function(v)SA:SetLockPart(v)end)
dropdown(L,"Cam Smooth",{"Smooth","Very Smooth","Instant"},"Smooth",function(v)SA:SetCamSmoothness(v)end)
dropdown(L,"Tracer Color",{"Red","Orange","Purple","Cyan","Green","Blue","Yellow","Pink","White"},"Purple",function(v)SA:SetTracerColor(v)end)
title(L,"Target Lock")
targetLockToggle=toggle(L,"Target Lock (L)","L",false,function(on)local ok2,msg=SA:ToggleTargetLock()if targetLockToggle then targetLockToggle.Set(ok2)end notify(t("Target Lock (L)"),msg,1.5)end,false)
SA.OnLockLost=function()if targetLockToggle then targetLockToggle.Set(false)end notify(t("Target Lock (L)"),"Alvo perdido",1.5)end
title(R,"Filtros")
toggle(R,"Team Check",nil,false,function(on)SA:SetTeamCheck(on)end,true,true)
toggle(R,"SafeZone Check",nil,true,function(on)SA:SetSafeZoneCheck(on)end,true,true)
toggle(R,"Ignore Low Lvl",nil,false,function(on)SA:SetIgnoreLowLevel(on)end,true,true)
dropdown(R,"Min Lvl",{"500","1000","1500","2000","2200","2400","2550"},"2000",function(v)SA:SetIgnoreLowLevelThreshold(tonumber(v) or 2000)end)
dropdown(R,"Priority",{"Nearest","Low HP","Looking At Me","Crosshair"},"Nearest",function(v)SA:SetTargetPriority(v)end)
title(R,"FOV")
dropdown(R,"Aim Mode",{"360","180","FOV"},"360",function(v)SA:SetAimMode(v)end)
dropdown(R,"FOV Mode",{"V1","V2"},"V1",function(v)SA:SetFOVMode(v)end)
dropdown(R,"FOV Radius",{"50","100","150","200","300","500","800"},"150",function(v)SA:SetFOVRadius(tonumber(v) or 150)end)
toggle(R,"Show FOV Circle",nil,false,function(on)SA:SetShowFOVCircle(on)end,true,true)
-- [REMOVED: ping visual]
SA:SetSilentPart("HumanoidRootPart") SA:SetPrediction(true) SA:SetPredictionAmount(0.12) SA:SetSilentSticky(true) SA:SetSkillSilent(true) SA:SetSilentTPDist(999) SA:SetSkillAimbotDist(999)
SA:SetLockPart("Head") SA:SetCamSmoothness("Smooth") SA:SetTracerColor("Purple")
SA:SetTeamCheck(false) SA:SetSafeZoneCheck(true) SA:SetIgnoreLowLevel(false) SA:SetIgnoreLowLevelThreshold(2000)
SA:SetTargetPriority("Nearest") SA:SetAimMode("360") SA:SetFOVMode("V1") SA:SetFOVRadius(150)
end) if not ok then warn("HardyWare pagina PVP: "..tostring(err)) end end
do local ok,err=pcall(function()
local p=pages["Misc"] local L,R=p.left,p.right
title(L,"speed")toggle(L,"speed_boost",nil,State.speedBoost,function(on)State.speedBoost=on _G.SetSpeedBoost(on)end,true,true)slider(L,"speed_mult",State.speedValue,0,10,function(v)State.speedValue=math.floor(v*100)/100 end)
title(L,"glitch_sg")toggle(L,"glitch_enabled",nil,State.GlideEnabled,function(on)State.GlideEnabled=on end,true,true)slider(L,"glide_speed",State.GlideSpeed,50,800,function(v)State.GlideSpeed=math.floor(v)end)slider(L,"glide_time",State.GlideTime*100,3,100,function(v)State.GlideTime=v/100 end)
title(L,"dash_length")toggle(L,"dash_enabled",nil,State.DashLengthEnabled,function(on)State.DashLengthEnabled=on if not on and player.Character then player.Character:SetAttribute("DashLength",1)player.Character:SetAttribute("DashLengthAir",1)end end,true,true)slider(L,"dash_dist",State.DashLengthValue,1,300,function(v)State.DashLengthValue=math.floor(v)end)
title(R,"jump")inputField(R,"jump_force",State.JumpForce,function(v)State.JumpForce=v end)toggle(R,"mobile_jump_btn",nil,false,function(on)_G.MobileJump.SetEnabled(on,true)end,true)
title(R,"extra")dropdown(R,"FastSkill Mode",{"Normal","Turbo","Max","UltraMax"},"UltraMax",function(v)_G.FpsOpt.fastSkillMode(v)end)toggle(R,"fastskill",nil,false,function(on)_G.FpsOpt.fastSkill(on) notify(t("notif_title"),on and ("FastSkill ON ["..tostring(_G.FpsOpt.fastSkillGetMode()).."]: gates por evento, input prioritario, VFX zero, reload/endlag off") or "FastSkill off: FPS, render, anims e ataque restaurados",2)end,true)toggle(R,"infinite_soru",nil,State.InfiniteSoruEnabled,function(on)toggleInfiniteSoru(on)end,true,true)toggle(R,"anti_stun",nil,State.AntiStunEnabled,function(on)toggleAntiStun(on)end,true,true)
title(R,"tab_fly")toggle(R,"fly_enabled","H",State.flyActive,function(on)State.flyActive=on if not on then if FlyVel then FlyVel:Destroy()FlyVel=nil end if player.Character and player.Character:FindFirstChild("Humanoid")then player.Character.Humanoid.PlatformStand=false end elseif player.Character and player.Character:FindFirstChild("Humanoid")then player.Character.Humanoid.PlatformStand=true end end,true,true)slider(R,"fly_speed",State.flySpeed,50,1000,function(v)State.flySpeed=math.floor(v)end)title(R,"controls")local info=Instance.new("TextLabel")info.Size=UDim2.new(1,0,0,80)info.BackgroundTransparency=1 info.Text=t("fly_info")info.TextColor3=C.Muted info.Font=Enum.Font.Gotham info.TextSize=11 info.TextXAlignment=Enum.TextXAlignment.Left info.TextWrapped=true info.ZIndex=3 info.Parent=R table.insert(TransRegistry,{obj=info,key="fly_info",prop="Text",suffix=""})
end) if not ok then warn("HardyWare pagina Misc: "..tostring(err)) end end
do local ok,err=pcall(function()
local p=pages["Misc"] local L=p.left
local FO=_G.FpsOpt
title(L,"FastSkill Avancado")
toggle(L,"Auto-aprender bloqueios",nil,false,function(on)FO.setLearn(on)end,true,true)
local holder=Instance.new("Frame")
holder.Size=UDim2.new(1,0,0,28)
holder.BackgroundColor3=C.Bg
holder.BackgroundTransparency=0.2
holder.BorderSizePixel=0
holder.ZIndex=4
holder.Parent=L
round(holder,6)
line(holder,C.Border,1,0.65)
local tb=Instance.new("TextBox")
tb.Size=UDim2.new(1,-12,1,0)
tb.Position=UDim2.new(0,6,0,0)
tb.BackgroundTransparency=1
tb.Text=""
tb.PlaceholderText="Bloqueios extras (attr/Value): Nome1, Nome2"
tb.PlaceholderColor3=C.Muted
tb.TextColor3=C.White
tb.Font=Enum.Font.Gotham
tb.TextSize=10
tb.TextXAlignment=Enum.TextXAlignment.Left
tb.ClearTextOnFocus=false
tb.ZIndex=5
tb.Parent=holder
tb.FocusLost:Connect(function() FO.setExtraBlockers(tb.Text) notify(t("notif_title"),"Bloqueios extras atualizados",1.6) end)
local learnedLbl=newLabel(L,"Aprendidos: (nenhum)",UDim2.new(1,0,0,44),UDim2.new(0,0,0,0),Enum.Font.Gotham,10,C.Muted)
learnedLbl.TextWrapped=true
learnedLbl.TextTruncate=Enum.TextTruncate.None
learnedLbl.TextYAlignment=Enum.TextYAlignment.Top
local rb=Instance.new("TextButton")
rb.Size=UDim2.new(1,0,0,30)
rb.BackgroundColor3=C.Surface
rb.BackgroundTransparency=0.45
rb.Text="Resetar bloqueios aprendidos"
rb.TextColor3=C.PinkSoft
rb.Font=Enum.Font.GothamBold
rb.TextSize=11
rb.AutoButtonColor=false
rb.ZIndex=4
rb.Parent=L
round(rb,7)
rowStyle(rb)
rb.MouseButton1Click:Connect(function() FO.resetLearned() notify(t("notif_title"),"Aprendidos resetados",1.6) end)
local hint=newLabel(L,"Ligue 'Auto-aprender', use as skills uma vez e o script descobre sozinho os marcadores de 'skill em uso' do jogo e passa a zera-los. Se souber o nome exato, escreva em Bloqueios extras.",UDim2.new(1,0,0,64),UDim2.new(0,0,0,0),Enum.Font.Gotham,9,C.Muted)
hint.TextWrapped=true
hint.TextTruncate=Enum.TextTruncate.None
hint.TextYAlignment=Enum.TextYAlignment.Top
task.spawn(function()
    while learnedLbl.Parent do
        local l=FO.getLearned()
        learnedLbl.Text="Aprendidos: "..(#l>0 and table.concat(l,", ") or "(nenhum)")
        task.wait(1)
    end
end)
end) if not ok then warn("HardyWare FastSkill avancado: "..tostring(err)) end end
do local ok,err=pcall(function()
local p=pages["Soru Macro"] local L,R=p.left,p.right
title(L,"skill_soru")toggle(L,"skill_soru",nil,State.SkillSoruEnabled,function(on)State.SkillSoruEnabled=on end,true,true)dropdown(L,"soru_weapon",{"Fruit","Melee","Sword","Gun"},"Fruit",function(v)State.SoruWeapon=v end)dropdown(L,"soru_skill",{"Z","X","C","V","F"},"Z",function(v)State.SoruSkill=v end)dropdown(L,"soru_delay",{"0.10s","0.20s","0.30s","0.40s","0.50s"},"0.30s",function(v)State.SoruDelay=tonumber(v:match("[%d%.]+")) or 0.30 end)
end) if not ok then warn("HardyWare pagina Soru Macro: "..tostring(err)) end end
do local p=pages["Glitch"]local L,R=p.left,p.right local S=GlitchV2.S title(L,"sanguine")toggle(L,"sanguine",nil,S.sanguineEnabled,function(on)S.sanguineEnabled=on end,true,true)inputField(L,"power",S.sanguinePower,function(v)S.sanguinePower=v end)inputField(L,"duration",S.sanguineDuration,function(v)S.sanguineDuration=v end)inputField(L,"min_charge",S.sanguineCharge,function(v)S.sanguineCharge=v end)title(L,"dtalon")toggle(L,"dtalon",nil,S.dtalonEnabled,function(on)S.dtalonEnabled=on end,true,true)inputField(L,"power",S.dtalonPower,function(v)S.dtalonPower=v end)inputField(L,"duration",S.dtalonDuration,function(v)S.dtalonDuration=v end)inputField(L,"min_charge",S.dtalonCharge,function(v)S.dtalonCharge=v end)title(R,"diamond")toggle(R,"diamond",nil,S.diamondEnabled,function(on)S.diamondEnabled=on end,true,true)inputField(R,"power",S.diamondPower,function(v)S.diamondPower=v end)inputField(R,"duration",S.diamondDuration,function(v)S.diamondDuration=v end)inputField(R,"min_charge",S.diamondCharge,function(v)S.diamondCharge=v end)title(R,"eclaw")toggle(R,"eclaw",nil,S.eclawEnabled,function(on)S.eclawEnabled=on end,true,true)inputField(R,"power",S.eclawPower,function(v)S.eclawPower=v end)inputField(R,"duration",S.eclawDuration,function(v)S.eclawDuration=v end)inputField(R,"min_charge",S.eclawCharge,function(v)S.eclawCharge=v end)title(R,"big_skin")toggle(R,"big_skin_toggle",nil,S.bigSkinBugEnabled,function(on)S.bigSkinBugEnabled=on end,true,true)updateCanvas(L)updateCanvas(R)end
do local ok,err=pcall(function()do local p=pages["Gun"]local L,R=p.left,p.right title(L,"gun_click")toggle(L,"enable_gun",nil,false,function(on)GunClickSL:SetEnabled(on)end,true)title(L,"m1_ext")toggle(L,"enable_m1",nil,false,function(on)M1Extender:Toggle(on)end,true)slider(L,"ext_range",50,10,100,function(v)M1Extender:SetRange(math.floor(v))end)title(L,"fa_title")toggle(L,"fa_enable",nil,false,function(on)_G.FastAttackMod:Toggle(on)end,true)dropdown(L,"fa_delay",{"0.12s","0.15s (Def)","0.20s","0.30s"},"0.15s (Def)",function(v)_G.FastAttackMod:SetDelay(v)end)title(R,"info")local info=Instance.new("TextLabel")info.Size=UDim2.new(1,0,0,100)info.BackgroundTransparency=1 info.Text=t("gun_info")info.TextColor3=C.Muted info.Font=Enum.Font.Gotham info.TextSize=11 info.TextXAlignment=Enum.TextXAlignment.Left info.TextWrapped=true info.ZIndex=3 info.Parent=R table.insert(TransRegistry,{obj=info,key="gun_info",prop="Text",suffix=""})updateCanvas(L)updateCanvas(R)end end) if not ok then warn("HardyWare pagina Gun: "..tostring(err)) end end
do local ok,err=pcall(function()do local p=pages["Hitbox"]local L,R=p.left,p.right title(L,"hb_expander")toggle(L,"hb_toggle",nil,false,function(on)State.HitboxExpander=on if on then HitboxExpander:Enable()else HitboxExpander:Disable()end end,true)slider(L,"hb_size",10,1,50,function(v)State.HitboxSize=math.floor(v)if State.HitboxExpander then HitboxExpander:Refresh()end end)toggle(L,"hb_npc",nil,false,function(on)State.HitboxNPCs=on if State.HitboxExpander then HitboxExpander:Refresh()end end,true)toggle(L,"hb_show",nil,false,function(on)State.HitboxVisual=on if State.HitboxExpander then HitboxExpander:Refresh()end end,true)title(R,"anti_combo")toggle(R,"portal_x_toggle",nil,false,function(on)State.AntiCombo=on if on and AntiCombo then AntiCombo:Enable()elseif not on and AntiCombo then AntiCombo:Disable()end end,true)toggle(R,"skull_x_toggle",nil,false,function(on)State.AntiComboSkull=on end,true)toggle(R,"soru_escape_toggle",nil,false,function(on)State.AntiComboSoru=on end,true)updateCanvas(L)updateCanvas(R)end end) if not ok then warn("HardyWare pagina Hitbox: "..tostring(err)) end end
_G.FpsOpt=(function()
local Lighting=game:GetService("Lighting")
local Players=game:GetService("Players")
local SPOOKY_FFLAGS={{"DFIntTaskSchedulerTargetFps","240"},{"FFlagDisablePostFx","True"},{"FIntFRMMaxGrassDistance","0"},{"FIntFRMMinGrassDistance","0"},{"DFIntDebugFRMQualityLevelOverride","1"},{"DFFlagTextureQualityOverrideEnabled","True"},{"DFIntTextureQualityOverride","0"}}
local M={}
local function newStore()
local s={items=setmetatable({},{__mode="k"}),conns={}}
function s.set(obj,prop,val)
if not obj then return end
local t=s.items[obj]
if not t then t={} s.items[obj]=t end
if t[prop]==nil then pcall(function() t[prop]=obj[prop] end) end
pcall(function() obj[prop]=val end)
end
function s.restore()
for _,c in pairs(s.conns) do pcall(function() c:Disconnect() end) end
s.conns={}
for obj,props in pairs(s.items) do
pcall(function() for p,v in pairs(props) do obj[p]=v end end)
end
s.items=setmetatable({},{__mode="k"})
end
return s
end
-- banco de flags: guarda o valor original (se o executor le) e restaura no desligar
local function newFlagBank()
local b={saved={}}
function b.set(name,val)
if b.saved[name]==nil then
local v,vn=DW_readFlag(name)
b.saved[name]={v=v,vn=vn}
end
return DW_applyFlag(name,val)
end
function b.restore()
for name,e in pairs(b.saved) do
if e.v~=nil then pcall(DW_applyFlag,e.vn or name,e.v) end
end
b.saved={}
end
return b
end
local function scanWorkspace(isAlive,fn)
task.spawn(function()
local ok,list=pcall(function() return workspace:GetDescendants() end)
if not ok then return end
for i=1,#list do
if not isAlive() then break end
fn(list[i])
if i%300==0 then task.wait() end
end
end)
end
local function disableFx(inst,s)
local c=inst.ClassName
if c=="ParticleEmitter" then s.set(inst,"Rate",0) s.set(inst,"Enabled",false)
elseif c=="Beam" or c=="Trail" or c=="Fire" or c=="Smoke" or c=="Sparkles" or c=="PointLight" or c=="SpotLight" or c=="SurfaceLight" or c=="Highlight" then s.set(inst,"Enabled",false)
elseif c=="Decal" or c=="Texture" then s.set(inst,"Texture","")
end
end
local function feature(apply)
local st={}
return function(on)
if on then
if st.s then return end
local s=newStore() st.s=s
st.extra=apply(s)
else
local s=st.s if not s then return end
st.s=nil s.restore()
if st.extra then pcall(st.extra) st.extra=nil end
end
end
end
M.lowTextures=feature(function(s)
local me=Players.LocalPlayer
local alive=true
local bank=newFlagBank()
bank.set("DFFlagTextureQualityOverrideEnabled","True")
bank.set("DFIntTextureQualityOverride","0")
s.set(workspace.Terrain,"Decoration",false)
local function low(inst)
local c=inst.ClassName
if c=="Decal" or c=="Texture" then
local ch=me.Character
if ch and inst:IsDescendantOf(ch) then return end
s.set(inst,"Texture","")
elseif c=="SurfaceAppearance" then
s.set(inst,"ColorMap","") s.set(inst,"NormalMap","") s.set(inst,"MetalnessMap","") s.set(inst,"RoughnessMap","")
elseif c=="Part" or c=="MeshPart" or c=="UnionOperation" or c=="WedgePart" then
local ch=me.Character
if ch and inst:IsDescendantOf(ch) then return end
s.set(inst,"Material",Enum.Material.SmoothPlastic)
end
end
scanWorkspace(function() return alive end,low)
table.insert(s.conns,workspace.DescendantAdded:Connect(low))
return function() alive=false bank.restore() end
end)
M.noShadows=feature(function(s)
local bank=newFlagBank()
bank.set("FIntRenderShadowIntensity","0")
s.set(Lighting,"GlobalShadows",false)
s.set(Lighting,"ShadowSoftness",0)
return function() bank.restore() end
end)
M.fullbright=feature(function(s)
s.set(Lighting,"Brightness",2)
s.set(Lighting,"Ambient",Color3.fromRGB(255,255,255))
end)
M.noFog=feature(function(s)
s.set(Lighting,"FogEnd",9e9)
end)
M.antiLag=feature(function(s)
local me=Players.LocalPlayer
local alive=true
local t=workspace.Terrain
s.set(t,"WaterWaveSize",0) s.set(t,"WaterWaveSpeed",0) s.set(t,"WaterReflectance",0)
s.set(Lighting,"GlobalShadows",false)
local function lite(inst)
local c=inst.ClassName
if c=="ParticleEmitter" or c=="Beam" or c=="Trail" or c=="Fire" or c=="Smoke" or c=="Sparkles" then
local ch=me.Character
if ch and inst:IsDescendantOf(ch) then return end
disableFx(inst,s)
end
end
scanWorkspace(function() return alive end,lite)
table.insert(s.conns,workspace.DescendantAdded:Connect(lite))
return function() alive=false end
end)
M.lowPing=feature(function(s)
    if type(DW_setfflag)~="function" then return end
    local NET_FLAGS={
        {"DFIntConnectionMTUSize","1400"},
        {"DFIntRakNetResendBufferArrayLength","128"},
        {"DFIntRakNetResendTimeoutMS","300"},
        {"DFIntNetworkPrediction","1"},
        {"DFIntNetworkLatencyTolerance","1"},
        {"FFlagEnableReducedLatency","True"},
        {"FFlagOptimizeNetwork","True"},
        {"FFlagOptimizeNetworkRouting","True"},
        {"FFlagOptimizeNetworkTransport","True"},
        {"DFIntServerTickRate","60"},
        {"DFIntServerPhysicsUpdateRate","60"},
    }
    local bank=newFlagBank()
    for i=1,#NET_FLAGS do bank.set(NET_FLAGS[i][1],NET_FLAGS[i][2]) end
    return function() bank.restore() end
end)
-- FastSkill: modo delay-zero (client-side). Nao altera ping nem cooldown do servidor.
-- Modos: Normal (throttle 80ms) / Turbo (todo frame + CAS + eventos) / Max (2x por frame, FPS destravado).
local FS_MODES={
    Normal={anim=8, unlockHz=0.08, cas=false, fps=360, frameLoop=false, renderLoop=false},
    Turbo ={anim=16,unlockHz=0,    cas=true,  fps=360, frameLoop=true,  renderLoop=false},
    Max   ={anim=30,unlockHz=0,    cas=true,  fps=999, frameLoop=true,  renderLoop=true},
    UltraMax={anim=99,unlockHz=0,  cas=true,  fps=9999,frameLoop=true,  renderLoop=true},
}
local FS={mode="UltraMax",learn=false,learned={},extra={}}
local function fsCfg() return FS_MODES[FS.mode] or FS_MODES.Turbo end
function M.fastSkillMode(v) if FS_MODES[v] then FS.mode=v end end
function M.fastSkillGetMode() return FS.mode end
function M.setLearn(v) FS.learn=v==true end
function M.getLearned()
    local out={}
    for n in pairs(FS.learned) do out[#out+1]=n end
    table.sort(out)
    return out
end
function M.resetLearned() FS.learned={} end
function M.setExtraBlockers(str)
    FS.extra={}
    for w in tostring(str or ""):gmatch("[^,;%s]+") do FS.extra[w]=true end
end
M.fastSkill=feature(function(s)
    local me=Players.LocalPlayer
    local ANIM_MAX_LEN=8
    local FPS_TARGET=fsCfg().fps
    local getCap=DW_getfpscap
    local setCap=DW_setfpscap
    local prevCap=nil
    local prevQuality=nil
    local bank=newFlagBank()
    local savedSpeeds=setmetatable({},{__mode="k"})
    local savedWeights=setmetatable({},{__mode="k"})
    local alive=true

    if type(getCap)=="function" then pcall(function() prevCap=getCap() end) end
    if type(setCap)=="function" then pcall(setCap,FPS_TARGET) end
    pcall(function()
        prevQuality=settings().Rendering.QualityLevel
        settings().Rendering.QualityLevel=Enum.QualityLevel.Level01
    end)

    local FAST_FLAGS={
        {"DFIntDebugFRMQualityLevelOverride","1"},
        {"DFFlagTextureQualityOverrideEnabled","True"},
        {"DFIntTextureQualityOverride","0"},
        {"FIntRenderShadowIntensity","0"},
        {"FFlagDisablePostFx","True"},
        {"FIntFRMMaxGrassDistance","0"},
        {"FIntFRMMinGrassDistance","0"},
        {"DFIntConnectionMTUSize","1400"},
        {"DFIntRakNetResendBufferArrayLength","128"},
        {"DFIntRakNetResendTimeoutMS","300"},
        {"DFIntNetworkPrediction","1"},
        {"DFIntNetworkLatencyTolerance","1"},
        {"FFlagEnableReducedLatency","True"},
        {"FFlagOptimizeNetwork","True"},
        {"FFlagOptimizeNetworkRouting","True"},
        {"FFlagOptimizeNetworkTransport","True"},
        {"FFlagTaskSchedulerLimitTargetFpsTo2402","False"},
        {"DFIntMaxFrameBufferSize","1"},
        {"DFIntInputBufferSize","1"},
        {"FFlagFRMDisable","True"},
    }
    pcall(function() settings().Rendering.EnableFRM=false end)
    pcall(function() settings().Network.IncomingReplicationLag=0 end)
    bank.set("DFIntTaskSchedulerTargetFps",tostring(FPS_TARGET))
    for i=1,#FAST_FLAGS do bank.set(FAST_FLAGS[i][1],FAST_FLAGS[i][2]) end

    local terrain=workspace.Terrain
    s.set(terrain,"Decoration",false)
    s.set(terrain,"WaterWaveSize",0)
    s.set(terrain,"WaterWaveSpeed",0)
    s.set(terrain,"WaterReflectance",0)
    s.set(terrain,"WaterTransparency",0)
    s.set(Lighting,"GlobalShadows",false)
    s.set(Lighting,"FogEnd",9e9)
    s.set(Lighting,"EnvironmentDiffuseScale",0)
    s.set(Lighting,"EnvironmentSpecularScale",0)

    local FX_SIMPLE={ParticleEmitter=1,Beam=2,Trail=2,Fire=2,Smoke=2,Sparkles=2,PointLight=2,SpotLight=2,SurfaceLight=2,Highlight=2,Decal=2,Texture=2}
    local POST={BloomEffect=true,BlurEffect=true,ColorCorrectionEffect=true,DepthOfFieldEffect=true,SunRaysEffect=true}
    local function fx(inst)
        local c=inst.ClassName
        local simple=FX_SIMPLE[c]
        if not (simple or POST[c] or c=="MeshPart" or c=="SurfaceAppearance" or c=="Sky" or c=="Atmosphere" or c=="Clouds") then return end
        local ch=me and me.Character
        if ch and inst:IsDescendantOf(ch) then return end
        if simple then
            disableFx(inst,s)
            if simple==1 then pcall(function() inst:Clear() end) end
        elseif POST[c] then
            if inst.Name~="HardyWareBlur" then s.set(inst,"Enabled",false) end
        elseif c=="Sky" then
            if inst.Name~="HardyWareGraySky" then
                s.set(inst,"StarCount",0)
                s.set(inst,"CelestialBodiesShown",false)
                s.set(inst,"SunAngularSize",0)
                s.set(inst,"MoonAngularSize",0)
            end
        elseif c=="Atmosphere" then
            s.set(inst,"Density",0)
            s.set(inst,"Parent",nil)
        elseif c=="Clouds" then
            s.set(inst,"Enabled",false)
            s.set(inst,"Parent",nil)
        elseif c=="MeshPart" then
            s.set(inst,"RenderFidelity",Enum.RenderFidelity.Performance)
            s.set(inst,"CastShadow",false)
        elseif c=="SurfaceAppearance" then
            s.set(inst,"Parent",nil)
        end
    end

    for _,v in ipairs(Lighting:GetChildren()) do
        if v.Name~="HardyWareBlur" and v.Name~="HardyWareGraySky" then
            fx(v)
        end
    end
    table.insert(s.conns,Lighting.DescendantAdded:Connect(function(inst)
        local c=inst.ClassName
        if POST[c] or c=="Atmosphere" or c=="Clouds" or c=="Sky" then fx(inst) end
    end))

    task.spawn(function()
        local ok,list=pcall(function() return workspace:GetDescendants() end)
        if not ok then return end
        for i=1,#list do
            if not alive then break end
            fx(list[i])
            if i%200==0 then task.wait() end
        end
    end)
    table.insert(s.conns,workspace.DescendantAdded:Connect(fx))

    -- Animacoes: reload/endlag/start somem na sua tela; o resto continua acelerado.
    local RELOAD_WORDS={"reload","recarreg","recharge","ammo","bullet","magazine","mag_","reloadanim","gunreload"}
    local START_WORDS={"cast","windup","wind-up","prepare","summon","startup","start_anim","startanim","skill_start","equip","unequip","sheath","drawweapon","draw_weapon","activation","activate","charge"}
    local ENDLAG_WORDS={"endlag","end_lag","aftercast","recover","recovery","comboend","combo_end","finisher","end_anim","endanim"}
    local function trackKey(tr)
        local parts={}
        local ok=pcall(function()
            parts[#parts+1]=tostring(tr.Name or "")
            local a=tr.Animation
            if a then
                parts[#parts+1]=tostring(a.Name or "")
                parts[#parts+1]=tostring(a.AnimationId or "")
            end
        end)
        if not ok then return "" end
        return string.lower(table.concat(parts," "))
    end
    local function hasAny(key,list)
        for i=1,#list do if string.find(key,list[i],1,true) then return true end end
        return false
    end
    local function hideTrack(tr)
        if savedSpeeds[tr]==nil then savedSpeeds[tr]=tr.Speed end
        if savedWeights[tr]==nil then savedWeights[tr]=tr.Weight end
        pcall(function() tr.Speed=100 end)
        pcall(function() tr:AdjustWeight(0,0) end)
    end
    local function applyTrack(tr)
        if not tr then return end
        local key=trackKey(tr)
        if tr.Looped then
            -- Recarga em loop (escopeta etc.) sai da tela sem Stop: o estado do jogo continua.
            if hasAny(key,RELOAD_WORDS) then hideTrack(tr) end
            return
        end
        if hasAny(key,RELOAD_WORDS) or hasAny(key,ENDLAG_WORDS) or hasAny(key,START_WORDS) then
            -- Weight 0 tira da tela; Speed 100 conclui na hora para liberar o estado.
            hideTrack(tr)
            return
        end
        if tr.Length>0 and tr.Length<=ANIM_MAX_LEN and tr.Speed~=fsCfg().anim then
            if savedSpeeds[tr]==nil then savedSpeeds[tr]=tr.Speed end
            pcall(function() tr.Speed=fsCfg().anim end)
        end
    end
    local function cancelActionAnims()
        local c=me.Character
        local hum=c and c:FindFirstChildOfClass("Humanoid")
        if not hum then return end
        local ok,tracks=pcall(function() return hum:GetPlayingAnimationTracks() end)
        if ok and type(tracks)=="table" then
            for i=1,#tracks do applyTrack(tracks[i]) end
        end
    end

    -- Troca rapida: o slot continua sendo o do jogo (sem risco de trocar errado);
    -- o FastSkill corta a animacao de equipar/guardar e libera o tool na hora.
    local equipHooked=setmetatable({},{__mode="k"})
    local toolEnabledConns={}
    local function forceTool(tool)
        if not tool then return end
        if tool.Enabled==false then pcall(function() tool.Enabled=true end) end
    end
    local function hookEquip(hum)
        if not hum or equipHooked[hum] then return end
        equipHooked[hum]=true
        if type(DW_hookfunction)~="function" then return end
        pcall(function()
            local oldEquip=hum.EquipTool
            if type(oldEquip)~="function" then return end
            local newEquip=DW_newcclosure(function(self,tool)
                local r=oldEquip(self,tool)
                forceTool(tool)
                cancelActionAnims()
                return r
            end)
            DW_hookfunction(oldEquip,newEquip)
        end)
        pcall(function()
            local oldUnequip=hum.UnequipTools
            if type(oldUnequip)~="function" then return end
            local newUnequip=DW_newcclosure(function(self)
                local r=oldUnequip(self)
                cancelActionAnims()
                return r
            end)
            DW_hookfunction(oldUnequip,newUnequip)
        end)
    end
    local toolConn=nil
    local function bindToolWatch(c)
        if not c then return end
        if toolConn then pcall(function() toolConn:Disconnect() end) toolConn=nil end
        for _,cn in ipairs(toolEnabledConns) do pcall(function() cn:Disconnect() end) end
        toolEnabledConns={}
        local function watchTool(tool)
            if not tool or not tool:IsA("Tool") then return end
            forceTool(tool)
            table.insert(toolEnabledConns,tool:GetPropertyChangedSignal("Enabled"):Connect(function()
                if alive and tool.Enabled==false then pcall(function() tool.Enabled=true end) end
            end))
        end
        watchTool(c:FindFirstChildOfClass("Tool"))
        toolConn=c.ChildAdded:Connect(function(inst)
            if inst:IsA("Tool") then
                watchTool(inst)
                cancelActionAnims()
            end
        end)
        table.insert(s.conns,toolConn)
        table.insert(s.conns,c.ChildRemoved:Connect(function(inst)
            if inst:IsA("Tool") then cancelActionAnims() end
        end))
    end

    local animPlayedConn=nil
    local function hookHumanoid(hum)
        if not hum then return end
        if animPlayedConn then pcall(function() animPlayedConn:Disconnect() end) animPlayedConn=nil end
        animPlayedConn=hum.AnimationPlayed:Connect(applyTrack)
        table.insert(s.conns,animPlayedConn)
        hookEquip(hum)
        local ok,tracks=pcall(function() return hum:GetPlayingAnimationTracks() end)
        if ok and type(tracks)=="table" then
            for i=1,#tracks do applyTrack(tracks[i]) end
        end
    end
    local char=me.Character
    hookHumanoid(char and char:FindFirstChildOfClass("Humanoid"))
    bindToolWatch(char)
    table.insert(s.conns,me.CharacterAdded:Connect(function(c)
        bindToolWatch(c)
        local hum=c:WaitForChild("Humanoid",5)
        if hum then hookHumanoid(hum) end
    end))

    -- Sweep leve: AnimationPlayed pega tudo; o Heartbeat so cobre animacao que escapou.
    local animScanLast=0
    local animConn=RunService.Heartbeat:Connect(function()
        if not alive then return end
        local now=os.clock()
        if now-animScanLast<0.5 then return end
        animScanLast=now
        local c=me.Character
        if not c then return end
        local hum=c:FindFirstChildOfClass("Humanoid")
        if not hum then return end
        local ok,tracks=pcall(function() return hum:GetPlayingAnimationTracks() end)
        if not ok or type(tracks)~="table" then return end
        for i=1,#tracks do applyTrack(tracks[i]) end
    end)

    local CANCEL_KEYS={Z=true,X=true,C=true,V=true,F=true}
    table.insert(s.conns,UserInputService.InputBegan:Connect(function(input,gp)
        if gp or not alive then return end
        if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
            cancelActionAnims()
        elseif input.UserInputType==Enum.UserInputType.Keyboard and CANCEL_KEYS[input.KeyCode.Name] then
            cancelActionAnims()
        end
    end))

    -- Ignora o bloqueio local do botao de ataque / tool desabilitada.
    local attackButtons={}
    local lastBtnScan=0
    local function scanAttackButtons()
        attackButtons={}
        local pg=me:FindFirstChild("PlayerGui")
        if not pg then return end
        local ok,list=pcall(function() return pg:GetDescendants() end)
        if not ok then return end
        for i=1,#list do
            local d=list[i]
            if d:IsA("GuiButton") then
                local n=string.lower(d.Name)
                if n:find("attack") or n:find("atacar") or n=="m1" or n:find("basicattack") or n:find("hitbutton") then
                    attackButtons[#attackButtons+1]=d
                end
            end
        end
    end
    local BLOCK_ATTRS={"AttackBlocked","AttackDisabled","BlockAttack","AttackLocked","isUsingSkill","UsingSkill","Busy","SkillBusy","EquipBlocked","SwitchBlocked","ToolBlocked","UnequipBlocked","Attacking","AttackCooldown","SkillCooldown","ActionLocked","CombatLock","NoAttack","Stunned","Stun","Frozen","Rooted"}
    local ALLOW_ATTRS={"CanAttack","AttackEnabled","CanEquip","CanSwitch","CanMove","CanUseSkills"}
    local BLOCK_SET,ALLOW_SET={},{}
    for i=1,#BLOCK_ATTRS do BLOCK_SET[BLOCK_ATTRS[i]]=true end
    for i=1,#ALLOW_ATTRS do ALLOW_SET[ALLOW_ATTRS[i]]=true end
    local function blockedName(n) return BLOCK_SET[n] or FS.learned[n] or FS.extra[n] end
    local function clearAttackAttrs(obj)
        if not obj then return end
        local ok,attrs=pcall(obj.GetAttributes,obj)
        if not ok or type(attrs)~="table" then return end
        for name,v in pairs(attrs) do
            if v==true and blockedName(name) then
                pcall(obj.SetAttribute,obj,name,false)
            elseif v==false and ALLOW_SET[name] then
                pcall(obj.SetAttribute,obj,name,true)
            elseif type(v)=="number" and v>0 and (FS.learned[name] or FS.extra[name]) then
                pcall(obj.SetAttribute,obj,name,0)
            end
        end
    end
    local function unlockAttack()
        local c=me.Character
        if not c then return end
        local tool=c:FindFirstChildOfClass("Tool")
        if tool then
            forceTool(tool)
            clearAttackAttrs(tool)
        end
        clearAttackAttrs(c)
        clearAttackAttrs(c:FindFirstChildOfClass("Humanoid"))
    end
    local function unlockAttackButtons()
        for i=1,#attackButtons do
            local b=attackButtons[i]
            if b.Parent then
                if b.Active==false then b.Active=true end
                if b.Visible==false then b.Visible=true end
                if b.Selectable==false then b.Selectable=true end
                if b.Interactable==false then b.Interactable=true end
            end
        end
    end
    local uiDirty=true
    local pgNow=me:FindFirstChild("PlayerGui")
    if pgNow then
        table.insert(s.conns,pgNow.DescendantAdded:Connect(function() uiDirty=true end))
    end
    -- Destravamento: eventos (zero atraso) + driver por frame (Stepped/Heartbeat/RenderStepped) conforme o modo.
    local function unlockTick()
        local now=os.clock()
        unlockAttack()
        unlockAttackButtons()
        if (uiDirty and now-lastBtnScan>1) or now-lastBtnScan>10 then
            lastBtnScan=now
            uiDirty=false
            scanAttackButtons()
        end
    end
    local lastUnlock=0
    local function driver(kind)
        if not alive then return end
        local cfg=fsCfg()
        if kind=="hb" then
            -- Normal: Heartbeat com throttle. Turbo/Max: Heartbeat so se nao ha Stepped (nunca), entao ignora.
            if cfg.frameLoop then return end
            local now=os.clock()
            if now-lastUnlock<cfg.unlockHz then return end
            lastUnlock=now
            unlockTick()
        elseif kind=="step" then
            if cfg.frameLoop then unlockTick() end
        elseif kind=="render" then
            if cfg.renderLoop then unlockTick() end
        end
    end
    table.insert(s.conns,RunService.Heartbeat:Connect(function() driver("hb") end))
    table.insert(s.conns,RunService.Stepped:Connect(function() driver("step") end))
    table.insert(s.conns,RunService.RenderStepped:Connect(function() driver("render") end))

    -- Watch por evento: no instante em que o jogo liga um bloqueio, ele e desligado (sem esperar o proximo frame).
    local VALUE_SKIP={Stun=true,Stunned=true,Frozen=true,Rooted=true}
    local watched=setmetatable({},{__mode="k"})
    local function watchValue(v)
        if watched[v] or not v:IsA("ValueBase") then return end
        if not blockedName(v.Name) or VALUE_SKIP[v.Name] then return end
        watched[v]=true
        local function clr()
            if not alive or not fsCfg().frameLoop then return end
            pcall(function()
                if v:IsA("BoolValue") then
                    if v.Value==true then v.Value=false end
                elseif v:IsA("NumberValue") or v:IsA("IntValue") then
                    if v.Value>0 then v.Value=0 end
                end
            end)
        end
        clr()
        table.insert(s.conns,v.Changed:Connect(clr))
    end
    local function watchAttrs(obj)
        if not obj or watched[obj] then return end
        watched[obj]=true
        clearAttackAttrs(obj)
        table.insert(s.conns,obj.AttributeChanged:Connect(function(name)
            if not alive or not fsCfg().frameLoop then return end
            local v=obj:GetAttribute(name)
            if v==true and blockedName(name) then
                pcall(obj.SetAttribute,obj,name,false)
            elseif v==false and ALLOW_SET[name] then
                pcall(obj.SetAttribute,obj,name,true)
            elseif type(v)=="number" and v>0 and (FS.learned[name] or FS.extra[name]) then
                pcall(obj.SetAttribute,obj,name,0)
            end
        end))
        for _,ch in ipairs(obj:GetChildren()) do watchValue(ch) end
        table.insert(s.conns,obj.ChildAdded:Connect(watchValue))
    end
    local function rewatch(obj)
        if not obj then return end
        for _,ch in ipairs(obj:GetChildren()) do watchValue(ch) end
    end
    local function watchChar(c)
        if not c then return end
        watchAttrs(c)
        watchAttrs(c:FindFirstChildOfClass("Humanoid"))
        watchAttrs(c:FindFirstChildOfClass("Tool"))
        table.insert(s.conns,c.ChildAdded:Connect(function(ch)
            if ch:IsA("Tool") or ch:IsA("Humanoid") then watchAttrs(ch) end
        end))
    end
    watchChar(me.Character)
    table.insert(s.conns,me.CharacterAdded:Connect(function(c) task.wait() watchChar(c) end))

    -- Auto-aprender: ao usar skill/M1, compara atributos e Values antes/depois. O que liga e DESLIGA sozinho
    -- (marca de "skill em uso") vira bloqueio aprendido. Nomes de estado normal ficam de fora.
    local LEARN_SKIP={"hold","charg","equip","aim","sprint","run","sit","jump","walk","fly","dash","combo","health","speed","level","team","mode","pvp","safe","zone","ping","target"}
    local function learnSkip(n)
        local l=string.lower(n)
        for i=1,#LEARN_SKIP do if string.find(l,LEARN_SKIP[i],1,true) then return true end end
        return false
    end
    local function snapshot()
        local out={}
        local c=me.Character
        if not c then return out end
        local objs={c,c:FindFirstChildOfClass("Humanoid"),c:FindFirstChildOfClass("Tool")}
        for oi=1,3 do
            local o=objs[oi]
            if o then
                local ok,a=pcall(o.GetAttributes,o)
                if ok then for n,v in pairs(a) do out[oi.."a"..n]={n=n,v=v} end end
                for _,ch in ipairs(o:GetChildren()) do
                    if ch:IsA("BoolValue") or ch:IsA("NumberValue") or ch:IsA("IntValue") then
                        out[oi.."v"..ch.Name]={n=ch.Name,v=ch.Value}
                    end
                end
            end
        end
        return out
    end
    local function active(v) return v==true or (type(v)=="number" and v>0) end
    local learnBusy=false
    local function learnFrom(before)
        task.wait(0.12)
        local after=snapshot()
        local cands={}
        for k,e in pairs(after) do
            local b=before[k]
            if active(e.v) and not (b and active(b.v)) and not learnSkip(e.n) and not FS.learned[e.n] and not BLOCK_SET[e.n] then
                cands[k]=e.n
            end
        end
        if next(cands)==nil then return end
        local deadline=os.clock()+2.5
        while alive and os.clock()<deadline and next(cands)~=nil do
            task.wait(0.1)
            local now=snapshot()
            for k,n in pairs(cands) do
                local e=now[k]
                if not e or not active(e.v) then
                    FS.learned[n]=true
                    cands[k]=nil
                    notify(t("notif_title"),"Bloqueio aprendido: "..n,2)
                    rewatch(me.Character)
                    rewatch(me.Character and me.Character:FindFirstChildOfClass("Tool"))
                end
            end
        end
    end
    table.insert(s.conns,UserInputService.InputBegan:Connect(function(input,gp)
        if gp or not alive or not FS.learn or learnBusy then return end
        local ut=input.UserInputType
        local isSkill=(ut==Enum.UserInputType.Keyboard and (input.KeyCode.Name=="Z" or input.KeyCode.Name=="X" or input.KeyCode.Name=="C" or input.KeyCode.Name=="V" or input.KeyCode.Name=="F")) or ut==Enum.UserInputType.MouseButton1
        if not isSkill then return end
        learnBusy=true
        local before=snapshot()
        task.spawn(function()
            pcall(learnFrom,before)
            learnBusy=false
        end)
    end))

    -- Prioridade de input: roda ANTES dos handlers do jogo (CAS High+) e limpa o gate no mesmo frame da tecla.
    local CAS=game:GetService("ContextActionService")
    pcall(function()
        CAS:BindActionAtPriority("HardyWareFastSkill",function(_,state)
            if alive and state==Enum.UserInputState.Begin and fsCfg().cas then
                unlockAttack()
                cancelActionAnims()
            end
            return Enum.ContextActionResult.Pass
        end,false,Enum.ContextActionPriority.High.Value+1000,
            Enum.KeyCode.Z,Enum.KeyCode.X,Enum.KeyCode.C,Enum.KeyCode.V,Enum.KeyCode.F,
            Enum.KeyCode.One,Enum.KeyCode.Two,Enum.KeyCode.Three,Enum.KeyCode.Four,
            Enum.UserInputType.MouseButton1)
    end)

    -- Troca rapida de item: sem atalho proprio para nao conflitar com o hotbar do jogo.
    -- O corte da animacao de equipar/guardar (bindToolWatch) ja deixa a troca instantanea.
    -- Preload em massa removido: era a maior fonte de travamento ao ligar o FastSkill.

    return function()
        alive=false
        pcall(function() animConn:Disconnect() end)
        pcall(function() CAS:UnbindAction("HardyWareFastSkill") end)
        for tr,spd in pairs(savedSpeeds) do
            pcall(function() tr.Speed=spd end)
        end
        for tr,w in pairs(savedWeights) do
            pcall(function() tr:AdjustWeight(w,0) end)
        end
        for _,cn in ipairs(toolEnabledConns) do pcall(function() cn:Disconnect() end) end
        if type(setCap)=="function" and prevCap~=nil then pcall(setCap,prevCap) end
        if prevQuality~=nil then pcall(function() settings().Rendering.QualityLevel=prevQuality end) end
        bank.restore()
    end
end)
M.graySky=feature(function(s)
for _,v in ipairs(Lighting:GetChildren()) do
if v:IsA("Sky") and v.Name~="HardyWareGraySky" then s.set(v,"Parent",nil) end
end
local sky=Instance.new("Sky")
sky.Name="HardyWareGraySky"
local tex="rbxassetid://11457548274"
sky.SkyboxBk=tex sky.SkyboxDn=tex sky.SkyboxFt=tex sky.SkyboxLf=tex sky.SkyboxRt=tex sky.SkyboxUp=tex
sky.CelestialBodiesShown=false sky.StarCount=0
sky.Parent=Lighting
return function() if sky then pcall(function() sky:Destroy() end) end end
end)
M.ultraPotato=feature(function(s)
local q
pcall(function() q=settings().Rendering.QualityLevel settings().Rendering.QualityLevel=Enum.QualityLevel.Level01 end)
local t=workspace.Terrain
s.set(t,"WaterWaveSize",0) s.set(t,"WaterWaveSpeed",0) s.set(t,"WaterReflectance",0) s.set(t,"WaterTransparency",0) s.set(t,"Decoration",false)
s.set(Lighting,"GlobalShadows",false) s.set(Lighting,"FogEnd",9e9)
for _,v in ipairs(Lighting:GetChildren()) do
if (v:IsA("PostProcessEffect") and v.Name~="HardyWareBlur") or v:IsA("Atmosphere") or v:IsA("Clouds") then s.set(v,"Enabled",false) end
end
local me=Players.LocalPlayer
local alive=true
local function fx(d)
local ch=me and me.Character
if ch and d:IsDescendantOf(ch) then return end
disableFx(d,s)
end
task.spawn(function()
local n=0
for _,d in ipairs(workspace:GetDescendants()) do
if not alive then break end
fx(d)
n=n+1 if n%400==0 then task.wait() end
end
end)
table.insert(s.conns,workspace.DescendantAdded:Connect(fx))
return function()
alive=false
pcall(function() if q~=nil then settings().Rendering.QualityLevel=q end end)
end
end)
M.hideV4=feature(function(s)
local function isFxName(n)
n=string.lower(n)
return n:find("v4") or n:find("awakening") or n:find("aura") or n:find("transformation")
end
local function hideIn(inst)
if inst and isFxName(inst.Name) then
for _,d in ipairs(inst:GetDescendants()) do disableFx(d,s) end
end
end
for _,d in ipairs(workspace:GetDescendants()) do hideIn(d) end
table.insert(s.conns,workspace.DescendantAdded:Connect(hideIn))
end)
M.fpsPreset=feature(function(s)
local q,fps
pcall(function() q=settings().Rendering.QualityLevel end)
local getCap=DW_getfpscap
local setCap=DW_setfpscap
if type(getCap)=="function" then
local ok,f=pcall(getCap) if ok then fps=f end
end
local bank=newFlagBank()
if type(setCap)=="function" then pcall(setCap,240) end
pcall(function() settings().Rendering.QualityLevel=Enum.QualityLevel.Level01 end)
s.set(Lighting,"GlobalShadows",false)
s.set(Lighting,"FogEnd",9e9)
for _,pair in ipairs(SPOOKY_FFLAGS) do bank.set(pair[1],pair[2]) end
return function()
pcall(function() if q~=nil then settings().Rendering.QualityLevel=q end end)
if fps~=nil and type(setCap)=="function" then pcall(setCap,fps) end
bank.restore()
end
end)
return M
end)()
-- ============================================================
-- KEYBOARD SOFTENER: elimina o delay de input do Roblox.
-- Zera o buffer de input, desativa o rate-limit do scheduler
-- e eleva a prioridade dos eventos de teclado/mouse.
-- Resultado: cada tecla chega ao jogo no mesmo frame que foi pressionada.
-- ============================================================
_G.KeyboardSoftener=(function()
local M={}
local active=false
local bank
local conns={}
local CAS=game:GetService("ContextActionService")
local function newFlagBank2()
    local b={saved={}}
    function b.set(name,val)
        if b.saved[name]==nil then
            local v,vn=DW_readFlag(name)
            b.saved[name]={v=v,vn=vn}
        end
        return DW_applyFlag(name,val)
    end
    function b.restore()
        for name,e in pairs(b.saved) do
            if e.v~=nil then pcall(DW_applyFlag,e.vn or name,e.v) end
        end
        b.saved={}
    end
    return b
end
-- Flags que reduzem o delay de input no nivel do scheduler
local INPUT_FLAGS={
    -- Desabilita o buffer de frames de input (input chega no mesmo frame)
    {"DFIntInputBufferSize","0"},
    -- Desabilita o rate-limit do scheduler de input
    {"DFIntInputLatencyMs","0"},
    {"DFIntMaxFrameBufferSize","1"},
    -- Remove o cap de FPS do scheduler para nao engolir frames de input
    {"FFlagTaskSchedulerLimitTargetFpsTo2402","False"},
    -- Desativa o FRM que pode segurar frames de input
    {"FFlagFRMDisable","True"},
    {"DFFlagDebugPauseVoxelizer","True"},
    -- Prioridade de rede para ACKs de input
    {"DFIntConnectionMTUSize","1400"},
    {"DFIntRakNetResendBufferArrayLength","128"},
    {"DFIntRakNetResendTimeoutMS","100"},
    {"DFIntNetworkPrediction","1"},
    {"DFIntNetworkLatencyTolerance","0"},
    {"FFlagEnableReducedLatency","True"},
    {"FFlagOptimizeNetwork","True"},
    {"FFlagOptimizeNetworkRouting","True"},
    {"FFlagOptimizeNetworkTransport","True"},
}
local function enable()
    if active then return end
    active=true
    bank=newFlagBank2()
    if type(DW_setfflag)=="function" then
        for _,pair in ipairs(INPUT_FLAGS) do
            bank.set(pair[1],pair[2])
        end
    end
    -- Zera IncomingReplicationLag (reduz delay de replicacao de posicao)
    pcall(function() settings().Network.IncomingReplicationLag=0 end)
    -- Desativa FRM no settings local
    pcall(function() settings().Rendering.EnableFRM=false end)
    -- Eleva prioridade de todos os inputs de teclado via CAS High+2000
    -- (roda antes de qualquer handler do jogo, incluindo o FastSkill do DW)
    local ok=pcall(function()
        CAS:BindActionAtPriority("DWKeyboardSoftener",function(_,state)
            -- pass-through; so estar ligado em High+2000 ja eleva a prioridade
            return Enum.ContextActionResult.Pass
        end,false,Enum.ContextActionPriority.High.Value+2000,
            Enum.KeyCode.Z,Enum.KeyCode.X,Enum.KeyCode.C,
            Enum.KeyCode.V,Enum.KeyCode.F,Enum.KeyCode.One,
            Enum.KeyCode.Two,Enum.KeyCode.Three,Enum.KeyCode.Four,
            Enum.UserInputType.MouseButton1,Enum.UserInputType.Touch,
            Enum.KeyCode.W,Enum.KeyCode.A,Enum.KeyCode.S,Enum.KeyCode.D)
    end)
end
local function disable()
    if not active then return end
    active=false
    if bank then bank.restore() bank=nil end
    pcall(function() settings().Network.IncomingReplicationLag=nil end)
    pcall(function() CAS:UnbindAction("DWKeyboardSoftener") end)
    for _,c in ipairs(conns) do pcall(function() c:Disconnect() end) end
    conns={}
end
function M:Enable() enable() end
function M:Disable() disable() end
function M:IsActive() return active end
return M
end)()
-- Liga o softener automaticamente ao iniciar
task.defer(function() _G.KeyboardSoftener:Enable() end)
-- ============================================================
do local ok,err=pcall(function()do local p=pages["Fps"]local L,R=p.left,p.right title(L,"ff_title")toggle(L,"fps_preset",nil,false,function(on)_G.FpsOpt.fpsPreset(on)end,true)toggle(L,"ultra_potato",nil,false,function(on)_G.FpsOpt.ultraPotato(on)end,true)toggle(L,"low_tex",nil,false,function(on)_G.FpsOpt.lowTextures(on)end,true)toggle(L,"no_shadows",nil,false,function(on)_G.FpsOpt.noShadows(on)end,true)toggle(L,"fullbright",nil,false,function(on)_G.FpsOpt.fullbright(on)end,true)title(R,"ff_more")toggle(R,"no_fog",nil,false,function(on)_G.FpsOpt.noFog(on)end,true)toggle(R,"gray_sky",nil,false,function(on)_G.FpsOpt.graySky(on)end,true)toggle(R,"hide_v4",nil,false,function(on)_G.FpsOpt.hideV4(on)end,true)toggle(R,"anti_lag",nil,false,function(on)_G.FpsOpt.antiLag(on)end,true)title(R,"Keyboard Softener")toggle(R,"Keyboard Softener (auto-on)",nil,true,function(on)if on then _G.KeyboardSoftener:Enable()else _G.KeyboardSoftener:Disable()end end,true)updateCanvas(L)updateCanvas(R)end end) if not ok then warn("HardyWare pagina Fps: "..tostring(err)) end end
_G.FastFlags=(function()
    local M={}
    local FILE="HardyWare/fastflags.json"
    local entries,byName={},{}
    local autoApply=false
    local PRESETS={
        ["FPS Max"]={
            {"DFIntTaskSchedulerTargetFps","360"},
            {"FFlagDisablePostFx","True"},
            {"FIntRenderShadowIntensity","0"},
            {"DFIntDebugFRMQualityLevelOverride","1"},
            {"DFIntTextureQualityOverride","0"},
            {"FIntFRMMaxGrassDistance","0"},
            {"FIntFRMMinGrassDistance","0"},
            {"FFlagDisablePlayerShadows","True"},
            {"DFFlagDebugPauseVoxelizer","True"},
        },
        ["Rede / Delay"]={
            {"DFIntConnectionMTUSize","1400"},
            {"DFIntRakNetResendBufferArrayLength","128"},
            {"DFIntRakNetResendTimeoutMS","300"},
            {"DFIntNetworkPrediction","1"},
            {"DFIntNetworkLatencyTolerance","1"},
            {"FFlagEnableReducedLatency","True"},
            {"FFlagOptimizeNetwork","True"},
            {"FFlagOptimizeNetworkRouting","True"},
            {"FFlagOptimizeNetworkTransport","True"},
            {"DFIntServerTickRate","60"},
            {"DFIntServerPhysicsUpdateRate","60"},
        },
        ["Visual Zero"]={
            {"FFlagDisablePostFx","True"},
            {"FFlagDisableBloom","True"},
            {"FFlagDisableDepthOfField","True"},
            {"FIntRenderShadowIntensity","0"},
            {"DFIntDebugFRMQualityLevelOverride","1"},
            {"FIntTerrainArraySliceSize","4"},
            {"FFlagDebugSkyGray","True"},
        },
    }
    local PRESET_NAMES={"FPS Max","Rede / Delay","Visual Zero","Competitivo"}
    local function norm(v)
        if type(v)=="boolean" then return v and "True" or "False" end
        return tostring(v)
    end
    local function validName(n)
        return type(n)=="string" and #n>0 and #n<=120 and n:match("^[%w_]+$")~=nil
    end
    local function ensure(name,value)
        if not validName(name) then return nil,"nome invalido (use letras, numeros e _)" end
        local e=byName[name]
        if e then e.value=norm(value) return e end
        e={name=name,value=norm(value),orig=nil,origName=nil,applied=false,status=""}
        entries[#entries+1]=e
        byName[name]=e
        return e
    end
    local function presetList(name)
        if name=="Competitivo" then
            local out={}
            for _,src in ipairs({"FPS Max","Rede / Delay","Visual Zero"}) do
                for _,pair in ipairs(PRESETS[src]) do out[#out+1]=pair end
            end
            return out
        end
        return PRESETS[name]
    end
    function M.available() return type(DW_setfflag)=="function" end
    function M.canRead() return type(DW_getfflag)=="function" end
    function M.get(name)
        local v=DW_readFlag(name)
        return v
    end
    function M.add(name,value) return ensure(name,value) end
    function M.remove(name)
        local e=byName[name]
        if not e then return false end
        byName[name]=nil
        for i=#entries,1,-1 do
            if entries[i]==e then table.remove(entries,i) break end
        end
        return true
    end
    function M.setValue(name,value)
        local e=byName[name]
        if not e then return false end
        e.value=norm(value)
        return true
    end
    function M.list() return entries end
    function M.presetNames() return PRESET_NAMES end
    function M.getAuto() return autoApply end
    function M.setAuto(v)
        autoApply=v==true
        M.save()
    end
    function M.apply(name)
        local e=byName[name]
        if not e then return false,"flag nao existe" end
        if type(DW_setfflag)~="function" then e.status="setfflag indisponivel" e.applied=false return false,e.status end
        if e.orig==nil then
            local v,vn=DW_readFlag(name)
            e.orig=v e.origName=vn
        end
        local ok,st,used=DW_applyFlag(name,e.value)
        e.applied=ok and true or false
        e.status=tostring(st)
        e.used=used
        return ok,st
    end
    function M.applyAll()
        local okc,fail=0,0
        for i=1,#entries do
            local ok=M.apply(entries[i].name)
            if ok then okc=okc+1 else fail=fail+1 end
        end
        return okc,fail
    end
    function M.restore(name)
        local e=byName[name]
        if not e then return false end
        if e.orig==nil or type(DW_setfflag)~="function" then e.applied=false return false end
        local ok=DW_applyFlag(e.origName or name,e.orig)
        if ok then e.applied=false e.status="restaurado" end
        return ok
    end
    function M.restoreAll()
        local n=0
        for i=1,#entries do
            if M.restore(entries[i].name) then n=n+1 end
        end
        return n
    end
    function M.applyPreset(name)
        local list=presetList(name)
        if not list then return 0,0 end
        local okc,fail=0,0
        for i=1,#list do
            ensure(list[i][1],list[i][2])
            local ok=M.apply(list[i][1])
            if ok then okc=okc+1 else fail=fail+1 end
        end
        return okc,fail
    end
    function M.import(text)
        text=tostring(text or "")
        local n=0
        local first=text:match("^%s*(.)")
        if first=="{" then
            local ok,data=pcall(function() return HttpService:JSONDecode(text) end)
            if ok and type(data)=="table" then
                for k,v in pairs(data) do
                    if type(k)=="string" and (type(v)=="string" or type(v)=="number" or type(v)=="boolean") then
                        ensure(k,v)
                        n=n+1
                    end
                end
                return n
            end
        end
        for line in (text.."\n"):gmatch("(.-)\n") do
            line=line:gsub("\r$","")
            if not line:match("^%s*%-%-") and not line:match("^%s*//") then
                local name,val=line:match("^%s*([%w_]+)%s*[=:]%s*(.-)%s*$")
                if name and val and val~="" then
                    val=val:gsub('^"(.*)"$','%1'):gsub("^'(.*)'$","%1")
                    ensure(name,val)
                    n=n+1
                end
            end
        end
        return n
    end
    function M.exportJSON()
        local obj={}
        for i=1,#entries do obj[entries[i].name]=entries[i].value end
        local ok,out=pcall(function() return HttpService:JSONEncode(obj) end)
        return ok and out or "{}"
    end
    function M.exportText()
        local out={}
        for i=1,#entries do out[#out+1]=entries[i].name.."="..entries[i].value end
        return table.concat(out,"\n")
    end
    function M.save()
        if type(writefile)~="function" then return false,"writefile indisponivel" end
        if type(makefolder)=="function" then pcall(makefolder,"HardyWare") end
        local data={auto=autoApply,flags={}}
        for i=1,#entries do data.flags[#data.flags+1]={name=entries[i].name,value=entries[i].value} end
        local ok,enc=pcall(function() return HttpService:JSONEncode(data) end)
        if not ok then return false,"falha ao gerar JSON" end
        local wok,werr=pcall(writefile,FILE,enc)
        if not wok then return false,tostring(werr) end
        return true
    end
    function M.load()
        if type(readfile)~="function" or type(isfile)~="function" then return false end
        local eok,exists=pcall(isfile,FILE)
        if not eok or not exists then return false end
        local rok,raw=pcall(readfile,FILE)
        if not rok or type(raw)~="string" then return false end
        local dok,data=pcall(function() return HttpService:JSONDecode(raw) end)
        if not dok or type(data)~="table" then return false end
        autoApply=data.auto==true
        if type(data.flags)=="table" then
            for i=1,#data.flags do
                local e=data.flags[i]
                if type(e)=="table" and type(e.name)=="string" then ensure(e.name,e.value or "") end
            end
        end
        return true
    end
    ensure("DFIntTaskSchedulerTargetFps","360")
    ensure("FFlagDisablePostFx","True")
    ensure("FIntRenderShadowIntensity","0")
    ensure("DFIntDebugFRMQualityLevelOverride","1")
    ensure("DFIntTextureQualityOverride","0")
    ensure("DFIntConnectionMTUSize","1400")
    ensure("DFIntNetworkPrediction","1")
    ensure("FFlagEnableReducedLatency","True")
    M.load()
    if autoApply then M.applyAll() end
    return M
end)()

do local ok,err=pcall(function()
local p=pages["FFlags"] local L,R=p.left,p.right
local M=_G.FastFlags
title(L,"FastFlags Editor")
local status=newLabel(L,"",UDim2.new(1,0,0,34),UDim2.new(0,0,0,0),Enum.Font.Gotham,10,C.Muted)
status.TextWrapped=true
status.TextTruncate=Enum.TextTruncate.None
status.TextYAlignment=Enum.TextYAlignment.Top
local ffHint=newLabel(L,"Verde = confirmada por leitura. Vermelha = o Roblox ignorou (fora da allowlist), nao tem como forcar. Branca = aplicada mas o executor nao le o valor de volta.",UDim2.new(1,0,0,42),UDim2.new(0,0,0,0),Enum.Font.Gotham,9,C.Muted)
ffHint.TextWrapped=true
ffHint.TextTruncate=Enum.TextTruncate.None
ffHint.TextYAlignment=Enum.TextYAlignment.Top
local function refresh(msg)
    local conf,sem,ign=0,0,0
    for _,e in ipairs(M.list()) do
        if e.status=="confirmado" then conf=conf+1
        elseif e.applied then sem=sem+1
        elseif e.status and e.status~="" and e.status~="restaurado" then ign=ign+1 end
    end
    status.Text=(msg and(msg.."\n") or "")..string.format("%d flags | %d confirmadas | %d sem leitura | %d ignoradas | set=%s get=%s",#M.list(),conf,sem,ign,M.available() and "OK" or "OFF",M.canRead() and "OK" or "OFF")
end
local function ffButton(parent,text,callback)
    local b=Instance.new("TextButton")
    b.Size=UDim2.new(1,0,0,30)
    b.BackgroundColor3=C.Surface
    b.BackgroundTransparency=0.45
    b.Text=text
    b.TextColor3=C.PinkSoft
    b.Font=Enum.Font.GothamBold
    b.TextSize=11
    b.AutoButtonColor=false
    b.ZIndex=4
    b.Parent=parent
    round(b,7)
    rowStyle(b)
    b.MouseEnter:Connect(function()tw(b,0.12,{BackgroundTransparency=0.25})end)
    b.MouseLeave:Connect(function()tw(b,0.12,{BackgroundTransparency=0.45})end)
    b.MouseButton1Click:Connect(function()
        local ok2,e2=pcall(callback)
        if not ok2 then notify(t("notif_title"),"Erro: "..tostring(e2),3) end
    end)
    return b
end
local function ffBox(parent,placeholder)
    local holder=Instance.new("Frame")
    holder.Size=UDim2.new(1,0,0,28)
    holder.BackgroundColor3=C.Bg
    holder.BackgroundTransparency=0.2
    holder.BorderSizePixel=0
    holder.ZIndex=4
    holder.Parent=parent
    round(holder,6)
    line(holder,C.Border,1,0.65)
    local tb=Instance.new("TextBox")
    tb.Size=UDim2.new(1,-12,1,0)
    tb.Position=UDim2.new(0,6,0,0)
    tb.BackgroundTransparency=1
    tb.Text=""
    tb.PlaceholderText=placeholder
    tb.PlaceholderColor3=C.Muted
    tb.TextColor3=C.White
    tb.Font=Enum.Font.Gotham
    tb.TextSize=10
    tb.TextXAlignment=Enum.TextXAlignment.Left
    tb.ClearTextOnFocus=false
    tb.ZIndex=5
    tb.Parent=holder
    return tb
end
local rebuildList
local presetChoice="FPS Max"
dropdown(L,"Preset",M.presetNames(),presetChoice,function(v)presetChoice=v end)
ffButton(L,"Aplicar preset",function()
    local okc,fail=M.applyPreset(presetChoice)
    rebuildList()
    refresh("Preset: "..presetChoice)
    notify(t("notif_title"),string.format("%s: %d ok / %d falhou",presetChoice,okc,fail),3)
end)
title(L,"Nova flag")
local nameBox=ffBox(L,"DFIntTaskSchedulerTargetFps")
local valueBox=ffBox(L,"360")
ffButton(L,"Adicionar / Atualizar",function()
    local name=nameBox.Text:gsub("%s+","")
    local e2,err2=M.add(name,valueBox.Text)
    if not e2 then notify(t("notif_title"),tostring(err2),3) return end
    M.apply(name)
    rebuildList()
    refresh("Flag: "..name)
end)
title(L,"Importar / Exportar")
local importBox=Instance.new("TextBox")
importBox.Size=UDim2.new(1,0,0,86)
importBox.BackgroundColor3=C.Bg
importBox.BackgroundTransparency=0.2
importBox.BorderSizePixel=0
importBox.Text=""
importBox.PlaceholderText='{"DFIntTaskSchedulerTargetFps":"360"} ou Nome=Valor por linha'
importBox.PlaceholderColor3=C.Muted
importBox.TextColor3=C.White
importBox.Font=Enum.Font.Gotham
importBox.TextSize=9
importBox.TextWrapped=true
importBox.TextXAlignment=Enum.TextXAlignment.Left
importBox.TextYAlignment=Enum.TextYAlignment.Top
importBox.ClearTextOnFocus=false
importBox.ZIndex=4
importBox.Parent=L
round(importBox,6)
line(importBox,C.Border,1,0.65)
ffButton(L,"Importar texto acima",function()
    local n=M.import(importBox.Text)
    rebuildList()
    refresh("Importadas: "..n)
end)
ffButton(L,"Exportar JSON (clipboard)",function()
    local json=M.exportJSON()
    local copied=false
    if type(setclipboard)=="function" then local okc=pcall(setclipboard,json) copied=okc end
    if not copied and type(toclipboard)=="function" then local okc=pcall(toclipboard,json) copied=okc end
    if not copied then importBox.Text=json end
    notify(t("notif_title"),copied and "JSON copiado" or "Sem clipboard: JSON no campo de texto",3)
end)
ffButton(L,"Salvar lista",function()
    local okc,err2=M.save()
    notify(t("notif_title"),okc and "Lista salva em HardyWare/fastflags.json" or("Falha: "..tostring(err2)),3)
end)
ffButton(L,"Restaurar originais",function()
    local n=M.restoreAll()
    refresh("Restaurados: "..n)
    notify(t("notif_title"),"Flags restauradas: "..n,3)
end)
title(R,"Flags")
local searchBox=ffBox(R,"Buscar flag...")
local listScroll=Instance.new("ScrollingFrame")
listScroll.Size=UDim2.new(1,0,0,360)
listScroll.BackgroundTransparency=1
listScroll.BorderSizePixel=0
listScroll.ScrollBarThickness=3
listScroll.ScrollBarImageColor3=C.Pink
listScroll.CanvasSize=UDim2.new(0,0,0,0)
listScroll.AutomaticCanvasSize=Enum.AutomaticSize.Y
listScroll.ScrollingDirection=Enum.ScrollingDirection.Y
listScroll.ZIndex=3
listScroll.Parent=R
local listLayout=Instance.new("UIListLayout")
listLayout.Padding=UDim.new(0,4)
listLayout.SortOrder=Enum.SortOrder.LayoutOrder
listLayout.Parent=listScroll
rebuildList=function()
    for _,c in ipairs(listScroll:GetChildren()) do
        if c:IsA("GuiObject") then c:Destroy() end
    end
    local q=string.lower(searchBox.Text or "")
    local shown=0
    for _,e2 in ipairs(M.list()) do
        if q=="" or string.find(string.lower(e2.name),q,1,true) then
            shown=shown+1
            local row=Instance.new("Frame")
            row.Size=UDim2.new(1,-6,0,32)
            row.BackgroundColor3=C.Surface
            row.BackgroundTransparency=0.55
            row.BorderSizePixel=0
            row.ZIndex=3
            row.Parent=listScroll
            round(row,6)
            local nameCol=C.Gray
            if e2.status=="confirmado" then nameCol=C.Green
            elseif e2.applied then nameCol=C.White
            elseif e2.status and e2.status~="" and e2.status~="restaurado" then nameCol=C.Red end
            local nl=newLabel(row,e2.name,UDim2.new(0.43,-6,1,0),UDim2.new(0,6,0,0),Enum.Font.Gotham,9,nameCol)
            nl.TextTruncate=Enum.TextTruncate.AtEnd
            local holder=Instance.new("Frame")
            holder.Size=UDim2.new(0.27,-2,1,-8)
            holder.Position=UDim2.new(0.44,0,0,4)
            holder.BackgroundColor3=C.Bg
            holder.BackgroundTransparency=0.2
            holder.BorderSizePixel=0
            holder.ZIndex=4
            holder.Parent=row
            round(holder,5)
            local tb=Instance.new("TextBox")
            tb.Size=UDim2.new(1,-8,1,0)
            tb.Position=UDim2.new(0,4,0,0)
            tb.BackgroundTransparency=1
            tb.Text=e2.value
            tb.TextColor3=C.PinkSoft
            tb.Font=Enum.Font.Gotham
            tb.TextSize=9
            tb.TextXAlignment=Enum.TextXAlignment.Left
            tb.ClearTextOnFocus=false
            tb.ZIndex=5
            tb.Parent=holder
            tb.FocusLost:Connect(function()
                M.setValue(e2.name,tb.Text)
                M.apply(e2.name)
                rebuildList()
                refresh("Aplicado: "..e2.name..": "..tostring(e2.status))
            end)
            local ab=Instance.new("TextButton")
            ab.Size=UDim2.new(0.12,-2,1,-8)
            ab.Position=UDim2.new(0.72,0,0,4)
            ab.BackgroundColor3=C.Bg
            ab.BackgroundTransparency=0.2
            ab.BorderSizePixel=0
            ab.Text="A"
            ab.TextColor3=C.PinkSoft
            ab.Font=Enum.Font.GothamBold
            ab.TextSize=10
            ab.AutoButtonColor=false
            ab.ZIndex=5
            ab.Parent=row
            round(ab,5)
            ab.MouseButton1Click:Connect(function()
                M.apply(e2.name)
                rebuildList()
                refresh("Aplicado: "..e2.name..": "..tostring(e2.status))
            end)
            local rb=Instance.new("TextButton")
            rb.Size=UDim2.new(0.12,-2,1,-8)
            rb.Position=UDim2.new(0.85,0,0,4)
            rb.BackgroundColor3=C.Bg
            rb.BackgroundTransparency=0.2
            rb.BorderSizePixel=0
            rb.Text="X"
            rb.TextColor3=C.Red
            rb.Font=Enum.Font.GothamBold
            rb.TextSize=10
            rb.AutoButtonColor=false
            rb.ZIndex=5
            rb.Parent=row
            round(rb,5)
            rb.MouseButton1Click:Connect(function()
                M.remove(e2.name)
                rebuildList()
                refresh("Removida: "..e2.name)
            end)
        end
    end
    listScroll.CanvasSize=UDim2.new(0,0,0,shown*36)
    refresh("Mostrando: "..shown)
end
searchBox:GetPropertyChangedSignal("Text"):Connect(function() rebuildList() end)
ffButton(R,"Aplicar todas",function()
    local okc,fail=M.applyAll()
    rebuildList()
    refresh("Aplicadas: "..okc.." / falhou: "..fail)
    notify(t("notif_title"),string.format("Aplicadas: %d | falhou: %d",okc,fail),3)
end)
ffButton(R,"Restaurar todas",function()
    local n=M.restoreAll()
    rebuildList()
    refresh("Restauradas: "..n)
end)
toggle(R,"Auto aplicar ao abrir",nil,M.getAuto(),function(on)
    M.setAuto(on)
    if on then M.applyAll() end
    rebuildList()
end,true)
rebuildList()
refresh()
end) if not ok then warn("HardyWare pagina FFlags: "..tostring(err)) end end

_G.MacroSys=(function()
local M={}
local VIM=game:GetService("VirtualInputManager")
local DIR="HardyWareMacros"
local macro={name="Macro1",events={}}
local recording,playing=false,false
local recStart=0
local downRec={}
local held={}
local speed=1
local loops=1
local loopGap=0.05
local minHold=0.02
M.ignore=function() return false end
M.onChange=nil
M.onStop=nil

local KEYCACHE
local DIGIT={["1"]="One",["2"]="Two",["3"]="Three",["4"]="Four",["5"]="Five",["6"]="Six",["7"]="Seven",["8"]="Eight",["9"]="Nine",["0"]="Zero"}
local function resolveKey(tok)
    if type(tok)~="string" or tok=="" then return nil end
    local low=tok:lower()
    if low=="m1" or low=="click" or low=="lmb" or low=="mouse1" or low=="mousebutton1" then return "MouseButton1" end
    if low=="m2" or low=="rclick" or low=="rmb" or low=="mouse2" or low=="mousebutton2" then return "MouseButton2" end
    if DIGIT[tok] then return DIGIT[tok] end
    if not KEYCACHE then
        KEYCACHE={}
        for _,kc in ipairs(Enum.KeyCode:GetEnumItems()) do KEYCACHE[kc.Name:lower()]=kc.Name end
    end
    return KEYCACHE[low]
end
local function num(tok)
    if not tok then return nil end
    local ms=tok:match("^([%d%.]+)ms$")
    if ms then return (tonumber(ms) or 0)/1000 end
    return tonumber(tok)
end
local function trim(s) return (s:gsub("^%s+",""):gsub("%s+$","")) end
local function r3(x) return math.floor(x*1000+0.5)/1000 end

local function fire() if M.onChange then pcall(M.onChange) end end

-- Gravacao ----------------------------------------------------------------
local function inputKey(input)
    if input.UserInputType==Enum.UserInputType.Keyboard then return input.KeyCode.Name end
    if input.UserInputType==Enum.UserInputType.MouseButton1 then return "MouseButton1" end
    if input.UserInputType==Enum.UserInputType.MouseButton2 then return "MouseButton2" end
    return nil
end
local function rec(input,down)
    if not recording or playing then return end
    if UserInputService:GetFocusedTextBox() then return end
    local k=inputKey(input)
    if not k or M.ignore(k) then return end
    if not down and not downRec[k] then return end
    downRec[k]=down or nil
    macro.events[#macro.events+1]={t=r3(os.clock()-recStart),k=k,d=down}
    fire()
end
UserInputService.InputBegan:Connect(function(i,gp) if not gp then rec(i,true) end end)
UserInputService.InputEnded:Connect(function(i) rec(i,false) end)

function M.setRecording(on)
    on=on==true
    if on==recording then return end
    if on then
        if playing then M.stop() end
        macro.events={}
        downRec={}
        recStart=os.clock()
        recording=true
    else
        recording=false
        local endT=r3(os.clock()-recStart)
        for k in pairs(downRec) do macro.events[#macro.events+1]={t=endT,k=k,d=false} end
        downRec={}
        local evs=macro.events
        if #evs>0 then
            local t0=evs[1].t
            for i=1,#evs do evs[i].t=r3(evs[i].t-t0) end
        end
    end
    fire()
end
function M.isRecording() return recording end
function M.isPlaying() return playing end

-- Reproducao --------------------------------------------------------------
local function send(k,down)
    if k=="MouseButton1" or k=="MouseButton2" then
        local loc=UserInputService:GetMouseLocation()
        VIM:SendMouseButtonEvent(loc.X,loc.Y,k=="MouseButton2" and 1 or 0,down,game,0)
    else
        local kc=Enum.KeyCode[k]
        if kc then VIM:SendKeyEvent(down,kc,false,game) end
    end
    held[k]=down or nil
end
local function waitUntil(target)
    while os.clock()<target do
        if not playing then return false end
        RunService.Heartbeat:Wait()
    end
    return playing
end
local function releaseAll()
    for k in pairs(held) do pcall(send,k,false) end
    held={}
end
function M.stop()
    if not playing then return end
    playing=false
    releaseAll()
    if M.onStop then pcall(M.onStop) end
    fire()
end
function M.play()
    if playing or recording then return false,"ocupado" end
    local evs=macro.events
    if #evs==0 then return false,"macro vazio" end
    playing=true
    fire()
    task.spawn(function()
        local n=0
        repeat
            local base=os.clock()
            local lastDown={}
            for i=1,#evs do
                local e=evs[i]
                if not waitUntil(base+e.t/speed) then break end
                if e.d then
                    lastDown[e.k]=os.clock()
                else
                    local need=(lastDown[e.k] or 0)+minHold
                    if os.clock()<need and not waitUntil(need) then break end
                end
                pcall(send,e.k,e.d)
            end
            n=n+1
            if loops>0 and n>=loops then break end
            if playing and loopGap>0 then waitUntil(os.clock()+loopGap) end
        until not playing
        if playing then
            playing=false
            releaseAll()
            if M.onStop then pcall(M.onStop) end
            fire()
        end
    end)
    return true
end

-- Dados ---------------------------------------------------------------------
function M.get() return macro end
function M.setSpeed(v) speed=math.clamp(tonumber(v) or 1,0.1,10) end
function M.setLoops(v) loops=math.max(0,math.floor(tonumber(v) or 1)) end
function M.setLoopGap(v) loopGap=math.max(0,tonumber(v) or 0) end
function M.setMinHold(v) minHold=math.clamp(tonumber(v) or 0.02,0.005,2) end
function M.setName(n) macro.name=tostring(n or "Macro") end
function M.clear() if playing then M.stop() end macro.events={} fire() end
function M.duration()
    local e=macro.events
    return #e>0 and e[#e].t or 0
end
function M.removeEvent(i)
    if macro.events[i] then table.remove(macro.events,i) fire() end
end
function M.addTap(key,hold,gapBefore)
    local k=resolveKey(tostring(key or ""))
    if not k then return false,"tecla invalida" end
    local evs=macro.events
    local start=(#evs>0 and evs[#evs].t or 0)+math.max(0,tonumber(gapBefore) or 0)
    hold=math.max(minHold,tonumber(hold) or minHold)
    evs[#evs+1]={t=r3(start),k=k,d=true}
    evs[#evs+1]={t=r3(start+hold),k=k,d=false}
    fire()
    return true
end

-- Importar / exportar -------------------------------------------------------
-- Texto:  Z 0.05 0.10  |  X  |  wait 0.3  |  click  |  down Z / up Z  |  2 (slot)  |  50ms
local function parseText(text)
    local cur,evs=0,{}
    for line in (text.."\n"):gmatch("(.-)\n") do
        line=trim(line:gsub("\r",""))
        if line~="" and not line:match("^#") and not line:match("^%-%-") and not line:match("^//") then
            local toks={}
            for w in line:gmatch("%S+") do toks[#toks+1]=w end
            local cmd=toks[1]:lower()
            if cmd=="wait" or cmd=="delay" or cmd=="sleep" then
                cur=cur+math.max(0,num(toks[2]) or 0)
            elseif cmd=="down" or cmd=="up" then
                local k=resolveKey(toks[2])
                if k then evs[#evs+1]={t=r3(cur),k=k,d=(cmd=="down")} end
            else
                local k=resolveKey(toks[1])
                if k then
                    local hold=math.max(minHold,num(toks[2]) or minHold)
                    local gap=math.max(0,num(toks[3]) or 0)
                    evs[#evs+1]={t=r3(cur),k=k,d=true}
                    cur=cur+hold
                    evs[#evs+1]={t=r3(cur),k=k,d=false}
                    cur=cur+gap
                end
            end
        end
    end
    return evs
end
function M.importText(text)
    text=tostring(text or "")
    local first=text:match("^%s*(.)")
    local evs
    if first=="{" or first=="[" then
        local ok,data=pcall(function() return HttpService:JSONDecode(text) end)
        if not ok or type(data)~="table" then return false,"JSON invalido" end
        local arr=data.events or data
        if type(arr)~="table" then return false,"sem eventos" end
        evs={}
        for idx,e in ipairs(arr) do
            if type(e)=="table" and tonumber(e.t) and type(e.d)=="boolean" then
                local k=resolveKey(tostring(e.k or ""))
                if k then evs[#evs+1]={t=tonumber(e.t),k=k,d=e.d,i=idx} end
            end
        end
        if type(data.name)=="string" and data.name~="" then macro.name=data.name end
    else
        evs=parseText(text)
        for i=1,#evs do evs[i].i=i end
    end
    if #evs==0 then return false,"nada para importar" end
    table.sort(evs,function(a,b) if a.t==b.t then return a.i<b.i end return a.t<b.t end)
    for i=1,#evs do evs[i].i=nil end
    if playing then M.stop() end
    macro.events=evs
    fire()
    return true,#evs
end
function M.exportJSON()
    local ok,out=pcall(function() return HttpService:JSONEncode({name=macro.name,events=macro.events}) end)
    return ok and out or "{}"
end
function M.exportText()
    local out={}
    local cur=0
    for _,e in ipairs(macro.events) do
        if e.t>cur then out[#out+1]="wait "..string.format("%.3f",e.t-cur) cur=e.t end
        out[#out+1]=(e.d and "down " or "up ")..e.k
    end
    return table.concat(out,"\n")
end

-- Arquivos ------------------------------------------------------------------
local function clean(n) n=tostring(n or ""):gsub("[^%w _%-]","") return trim(n) end
function M.save(name)
    name=clean(name~=nil and name or macro.name)
    if name=="" then return false,"nome vazio" end
    if type(writefile)~="function" then return false,"writefile indisponivel" end
    if type(makefolder)=="function" then pcall(makefolder,DIR) end
    macro.name=name
    local ok,err=pcall(writefile,DIR.."/"..name..".json",M.exportJSON())
    if not ok then return false,tostring(err) end
    return true,name
end
function M.load(name)
    name=clean(name)
    if type(readfile)~="function" or type(isfile)~="function" then return false,"readfile indisponivel" end
    local path=DIR.."/"..name..".json"
    local okf,exists=pcall(isfile,path)
    if not okf or not exists then return false,"nao existe" end
    local ok,raw=pcall(readfile,path)
    if not ok then return false,"falha ao ler" end
    local good,n=M.importText(raw)
    if good then macro.name=name end
    return good,n
end
function M.delete(name)
    name=clean(name)
    if type(delfile)~="function" or type(isfile)~="function" then return false end
    local path=DIR.."/"..name..".json"
    local ok,exists=pcall(isfile,path)
    if ok and exists then pcall(delfile,path) return true end
    return false
end
function M.list()
    local out={}
    if type(listfiles)~="function" then return out end
    if type(isfolder)=="function" then
        local ok,ex=pcall(isfolder,DIR)
        if not ok or not ex then return out end
    end
    local ok,files=pcall(listfiles,DIR)
    if not ok or type(files)~="table" then return out end
    for _,path in ipairs(files) do
        local f=tostring(path):match("([^/\\]+)%.json$")
        if f then out[#out+1]=f end
    end
    table.sort(out)
    return out
end
return M
end)()

do local ok,err=pcall(function()
local p=pages["Macro"] local L,R=p.left,p.right
local MS=_G.MacroSys

local function mButton(parent,text,callback)
    local b=Instance.new("TextButton")
    b.Size=UDim2.new(1,0,0,30)
    b.BackgroundColor3=C.Surface
    b.BackgroundTransparency=0.45
    b.Text=text
    b.TextColor3=C.PinkSoft
    b.Font=Enum.Font.GothamBold
    b.TextSize=11
    b.AutoButtonColor=false
    b.ZIndex=4
    b.Parent=parent
    round(b,7)
    rowStyle(b)
    b.MouseEnter:Connect(function()tw(b,0.12,{BackgroundTransparency=0.25})end)
    b.MouseLeave:Connect(function()tw(b,0.12,{BackgroundTransparency=0.45})end)
    b.MouseButton1Click:Connect(function()
        local ok2,e2=pcall(callback)
        if not ok2 then notify(t("notif_title"),"Erro: "..tostring(e2),3) end
    end)
    return b
end
local function mBox(parent,placeholder,default)
    local holder=Instance.new("Frame")
    holder.Size=UDim2.new(1,0,0,28)
    holder.BackgroundColor3=C.Bg
    holder.BackgroundTransparency=0.2
    holder.BorderSizePixel=0
    holder.ZIndex=4
    holder.Parent=parent
    round(holder,6)
    line(holder,C.Border,1,0.65)
    local tb=Instance.new("TextBox")
    tb.Size=UDim2.new(1,-12,1,0)
    tb.Position=UDim2.new(0,6,0,0)
    tb.BackgroundTransparency=1
    tb.Text=default or ""
    tb.PlaceholderText=placeholder
    tb.PlaceholderColor3=C.Muted
    tb.TextColor3=C.White
    tb.Font=Enum.Font.Gotham
    tb.TextSize=10
    tb.TextXAlignment=Enum.TextXAlignment.Left
    tb.ClearTextOnFocus=false
    tb.ZIndex=5
    tb.Parent=holder
    return tb
end

-- teclas de bind e hub nao entram na gravacao
MS.ignore=function(k)
    if k=="LeftControl" or k=="F2" then return true end
    for _,id in ipairs({"Gravar Macro","Tocar Macro"}) do
        local kc=BindKeys[id]
        if kc and kc.Name==k then return true end
    end
    return false
end

title(L,"Macro Recorder")
local status=newLabel(L,"",UDim2.new(1,0,0,34),UDim2.new(0,0,0,0),Enum.Font.Gotham,10,C.Muted)
status.TextWrapped=true
status.TextTruncate=Enum.TextTruncate.None
status.TextYAlignment=Enum.TextYAlignment.Top

local recToggle,playToggle
recToggle=toggle(L,"Gravar Macro",nil,false,function(on)
    if on and MS.isPlaying() then MS.stop() end
    MS.setRecording(on)
    notify(t("notif_title"),on and "Gravando: aperte as teclas/skills (desligue pra parar)" or ("Macro gravado: "..#MS.get().events.." eventos"),2)
end,false,true)
SaveRegistry.toggles["t_"..tostring(_saveCounter)]=nil
playToggle=toggle(L,"Tocar Macro",nil,false,function(on)
    if on then
        local ok2,why=MS.play()
        if not ok2 then
            playToggle.Set(false)
            notify(t("notif_title"),"Nao tocou: "..tostring(why),2)
        end
    else
        MS.stop()
    end
end,false,true)
SaveRegistry.toggles["t_"..tostring(_saveCounter)]=nil
MS.onStop=function() if playToggle then playToggle.Set(false) end end

slider(L,"Velocidade (x)",1,0.25,4,function(v)MS.setSpeed(v)end)
inputField(L,"Repeticoes (0 = infinito)",1,function(v)MS.setLoops(v)end)
inputField(L,"Intervalo entre loops (s)",0.05,function(v)MS.setLoopGap(v)end)
inputField(L,"Hold minimo (s)",0.02,function(v)MS.setMinHold(v)end)

local hint=newLabel(L,"Gravar: liga 'Gravar Macro', aperta Z/X/C/M1... e desliga. O tempo exato entre as teclas e salvo. Bind: clique no botao ao lado do toggle e aperte a tecla.",UDim2.new(1,0,0,52),UDim2.new(0,0,0,0),Enum.Font.Gotham,9,C.Muted)
hint.TextWrapped=true
hint.TextTruncate=Enum.TextTruncate.None
hint.TextYAlignment=Enum.TextYAlignment.Top

title(L,"Adicionar toque manual")
local addKey=mBox(L,"Tecla (Z, X, C, V, F, 1-4, M1)","Z")
local addHold=mBox(L,"Hold (s)","0.05")
local addGap=mBox(L,"Espera antes (s)","0.10")
mButton(L,"Adicionar toque no fim",function()
    local okk,why=MS.addTap(addKey.Text,tonumber(addHold.Text),tonumber(addGap.Text))
    if not okk then notify(t("notif_title"),tostring(why),2) end
end)
mButton(L,"Limpar macro",function() MS.clear() end)

title(R,"Salvar / Carregar")
local nameBox=mBox(R,"Nome do macro","Macro1")
local selected=nil
local selLabel=newLabel(R,"Selecionado: (nenhum)",UDim2.new(1,0,0,18),UDim2.new(0,12,0,0),Enum.Font.Gotham,11,C.PinkSoft)
mButton(R,"Salvar macro",function()
    local okk,res=MS.save(nameBox.Text~="" and nameBox.Text or nil)
    notify(t("notif_title"),okk and ("Salvo: "..tostring(res)) or ("Falha: "..tostring(res)),2.5)
end)
mButton(R,"Proximo salvo (selecionar)",function()
    local l=MS.list()
    if #l==0 then notify(t("notif_title"),"Nenhum macro salvo",2) return end
    local idx=1
    if selected then for i,v in ipairs(l) do if v==selected then idx=i%#l+1 break end end end
    selected=l[idx]
    selLabel.Text="Selecionado: "..selected
end)
mButton(R,"Carregar selecionado",function()
    if not selected then notify(t("notif_title"),"Selecione um macro",2) return end
    local okk,res=MS.load(selected)
    if okk then nameBox.Text=selected end
    notify(t("notif_title"),okk and ("Carregado: "..selected.." ("..tostring(res).." ev)") or ("Falha: "..tostring(res)),2.5)
end)
mButton(R,"Deletar selecionado",function()
    if selected and MS.delete(selected) then
        notify(t("notif_title"),"Deletado: "..selected,2)
        selected=nil
        selLabel.Text="Selecionado: (nenhum)"
    end
end)

title(R,"Importar / Exportar")
local importBox=Instance.new("TextBox")
importBox.Size=UDim2.new(1,0,0,86)
importBox.BackgroundColor3=C.Bg
importBox.BackgroundTransparency=0.2
importBox.BorderSizePixel=0
importBox.Text=""
importBox.PlaceholderText="Cole JSON exportado ou texto:\nZ 0.05 0.10\nwait 0.3\nX\nclick"
importBox.PlaceholderColor3=C.Muted
importBox.TextColor3=C.White
importBox.Font=Enum.Font.Gotham
importBox.TextSize=9
importBox.TextWrapped=true
importBox.MultiLine=true
importBox.TextXAlignment=Enum.TextXAlignment.Left
importBox.TextYAlignment=Enum.TextYAlignment.Top
importBox.ClearTextOnFocus=false
importBox.ZIndex=4
importBox.Parent=R
round(importBox,6)
line(importBox,C.Border,1,0.65)
mButton(R,"Importar (JSON ou texto)",function()
    local okk,res=MS.importText(importBox.Text)
    notify(t("notif_title"),okk and ("Importado: "..tostring(res).." eventos") or ("Falha: "..tostring(res)),2.5)
end)
local function toClip(str,label)
    local copied=false
    if type(setclipboard)=="function" then copied=pcall(setclipboard,str) end
    if not copied and type(toclipboard)=="function" then copied=pcall(toclipboard,str) end
    if not copied then importBox.Text=str end
    notify(t("notif_title"),copied and (label.." copiado") or "Sem clipboard: texto no campo acima",2.5)
end
mButton(R,"Exportar JSON (clipboard)",function() toClip(MS.exportJSON(),"JSON") end)
mButton(R,"Exportar texto (clipboard)",function() toClip(MS.exportText(),"Texto") end)

title(R,"Passos do macro")
local list=Instance.new("ScrollingFrame")
list.Size=UDim2.new(1,0,0,220)
list.BackgroundTransparency=1
list.BorderSizePixel=0
list.ScrollBarThickness=3
list.ScrollBarImageColor3=C.Pink
list.CanvasSize=UDim2.new(0,0,0,0)
list.AutomaticCanvasSize=Enum.AutomaticSize.Y
list.ScrollingDirection=Enum.ScrollingDirection.Y
list.ZIndex=3
list.Parent=R
local ll=Instance.new("UIListLayout")
ll.Padding=UDim.new(0,3)
ll.SortOrder=Enum.SortOrder.LayoutOrder
ll.Parent=list

local dirty=true
local function rebuild()
    for _,c in ipairs(list:GetChildren()) do
        if c:IsA("GuiObject") then c:Destroy() end
    end
    local evs=MS.get().events
    local shown=math.min(#evs,120)
    for i=1,shown do
        local e=evs[i]
        local row=Instance.new("Frame")
        row.Size=UDim2.new(1,-6,0,24)
        row.BackgroundColor3=C.Surface
        row.BackgroundTransparency=0.55
        row.BorderSizePixel=0
        row.LayoutOrder=i
        row.ZIndex=3
        row.Parent=list
        round(row,6)
        newLabel(row,string.format("%3d   %7.3fs   %-14s %s",i,e.t,e.k,e.d and "DOWN" or "UP"),UDim2.new(1,-34,1,0),UDim2.new(0,8,0,0),Enum.Font.Code,10,e.d and C.White or C.Gray)
        local rb=Instance.new("TextButton")
        rb.Size=UDim2.new(0,22,0,18)
        rb.AnchorPoint=Vector2.new(1,0.5)
        rb.Position=UDim2.new(1,-4,0.5,0)
        rb.BackgroundColor3=C.Bg
        rb.BackgroundTransparency=0.2
        rb.BorderSizePixel=0
        rb.Text="X"
        rb.TextColor3=C.Red
        rb.Font=Enum.Font.GothamBold
        rb.TextSize=10
        rb.AutoButtonColor=false
        rb.ZIndex=5
        rb.Parent=row
        round(rb,5)
        rb.MouseButton1Click:Connect(function() MS.removeEvent(i) end)
    end
    if #evs>shown then
        local more=newLabel(list,"... +"..(#evs-shown).." eventos (exporte para ver tudo)",UDim2.new(1,-6,0,18),UDim2.new(0,0,0,0),Enum.Font.Gotham,9,C.Muted)
        more.LayoutOrder=shown+1
    end
    dirty=false
end
MS.onChange=function() dirty=true end

task.spawn(function()
    local last=0
    while status.Parent do
        local m=MS.get()
        local state=MS.isRecording() and "GRAVANDO" or (MS.isPlaying() and "TOCANDO" or "parado")
        status.Text=string.format("%s | %d eventos | %.2fs | %s",tostring(m.name),#m.events,MS.duration(),state)
        local now=os.clock()
        if dirty and (not MS.isRecording() or now-last>0.6) then
            last=now
            rebuild()
        end
        task.wait(0.15)
    end
end)
end) if not ok then warn("HardyWare pagina Macro: "..tostring(err)) end end

_G.CharMods=(function()
local M={}
local Players=game:GetService("Players")
local RunService=game:GetService("RunService")
local me=Players.LocalPlayer
local scale=5
local giantOn=false
local giantConn=nil
local korbloxMeshes={}
local function applyGiant(s)
local char=me.Character
local hum=char and char:FindFirstChildOfClass("Humanoid")
if not char or not hum then return end
pcall(function()
hum:SetStateEnabled(Enum.HumanoidStateType.Seated,false)
hum.Sit=false
if not char:GetAttribute("OrigCharScale") then char:SetAttribute("OrigCharScale",char:GetScale() or 1) end
char:ScaleTo((char:GetAttribute("OrigCharScale") or 1)*s)
hum.HipHeight=2*s
end)
if not giantConn then
giantConn=RunService.Stepped:Connect(function()
local c=me.Character
if c and giantOn then
local h=c:FindFirstChildOfClass("Humanoid")
if h then h:SetStateEnabled(Enum.HumanoidStateType.Seated,false) if h.Sit then h.Sit=false end end
for _,p in ipairs(c:GetDescendants()) do
if p:IsA("BasePart") and p.Name~="HumanoidRootPart" then p.CanCollide=false end
end
end
end)
end
end
local function restoreGiant()
if giantConn then giantConn:Disconnect() giantConn=nil end
local char=me.Character
local hum=char and char:FindFirstChildOfClass("Humanoid")
if not char or not hum then return end
pcall(function()
hum:SetStateEnabled(Enum.HumanoidStateType.Seated,true)
hum.Sit=false
char:ScaleTo(char:GetAttribute("OrigCharScale") or 1)
hum.HipHeight=2
for _,p in ipairs(char:GetDescendants()) do
if p:IsA("BasePart") then p.CanCollide=true end
end
end)
end
function M.giant(v)
giantOn=v
if v then applyGiant(scale) else restoreGiant() end
end
function M.setScale(n)
scale=n
if giantOn then applyGiant(scale) end
end
function M.korblox(v)
local char=me.Character
if not char then return end
local rl=char:FindFirstChild("RightUpperLeg")
local rl2=char:FindFirstChild("RightLowerLeg")
local rf=char:FindFirstChild("RightFoot")
if v then
if rl then
rl.Transparency=1
for _,c in pairs(rl:GetChildren()) do if c:IsA("SpecialMesh") then c:Destroy() end end
local mesh=Instance.new("SpecialMesh",rl)
mesh.MeshId="rbxassetid://139607718"
mesh.TextureId="rbxassetid://139607673"
mesh.Scale=Vector3.new(1,1,1)
table.insert(korbloxMeshes,mesh)
end
if rl2 then rl2.Transparency=1 end
if rf then rf.Transparency=1 end
else
for _,m in pairs(korbloxMeshes) do pcall(function() m:Destroy() end) end
korbloxMeshes={}
if rl then rl.Transparency=0 end
if rl2 then rl2.Transparency=0 end
if rf then rf.Transparency=0 end
end
end
function M.headless(v)
local char=me.Character
if not char then return end
local head=char:FindFirstChild("Head")
if head then
head.Transparency=v and 1 or 0
local face=head:FindFirstChild("face")
if face then face.Transparency=v and 1 or 0 end
end
for _,item in ipairs(char:GetChildren()) do
if item:IsA("Accessory") then
local handle=item:FindFirstChild("Handle")
if handle then
local att=handle:FindFirstChildOfClass("Attachment")
local attName=att and att.Name or ""
local isHead=attName:find("Hat") or attName:find("Hair") or attName:find("Face") or attName:find("Head") or item.AccessoryType==Enum.AccessoryType.Hair or item.AccessoryType==Enum.AccessoryType.Hat or item.AccessoryType==Enum.AccessoryType.Face
if isHead then
handle.Transparency=v and 1 or 0
for _,d in ipairs(handle:GetDescendants()) do
if d:IsA("BasePart") or d:IsA("Decal") then d.Transparency=v and 1 or 0 end
end
end
end
end
end
end
me.CharacterAdded:Connect(function()
task.wait(0.5)
if giantOn then applyGiant(scale) end
end)
return M
end)()
do local ok,err=pcall(function()
local p=pages["Giant Mode"] local L,R=p.left,p.right
title(L,"mod_giant")
toggle(L,"mod_giant",nil,false,function(on)_G.CharMods.giant(on)end,true)dropdown(L,"mod_giant_size",{"2x","5x (Def)","10x","50x","100x","500x"},"5x (Def)",function(v)_G.CharMods.setScale(tonumber(string.match(v,"%d+")) or 5)end)
end) if not ok then warn("HardyWare pagina Giant Mode: "..tostring(err)) end end
_G.SkillBL=(function()
local M={}
local Players=game:GetService("Players")
local UIS=game:GetService("UserInputService")
local me=Players.LocalPlayer
local enabled=true
local flags={
Melee={all=false,Z=false,X=false,C=false},
Fruit={all=false,M1=false,Z=false,X=false,C=false,V=false,F=false},
Sword={all=false,Z=false,X=false},
Gun={all=false,Z=false,X=false,M1=false}
}
local SKILL_KEYS={Z=true,X=true,C=true,V=true,F=true}
local SWORD_WORDS={"sword","katana","blade","yoru","cursed","scythe","saber","dagger","trident","cutlass","pole","mace","cane","pipe","bisento","saddi","shisui","rengoku","wando","yama","tushita","koko","jitte","anchor","lamp","hallow","warden"}
local lastKey,lastKeyTime=nil,0
local function categoryOf(tool)
if not tool then return "Melee" end
local tt=string.lower(tostring(tool.ToolTip or ""))
if tt:find("sword") or tt:find("espada") then return "Sword" end
if tt:find("gun") or tt:find("pistol") or tt:find("arma") then return "Gun" end
if tt:find("fruit") or tt:find("fruta") then return "Fruit" end
if tt:find("melee") or tt:find("combat") then return "Melee" end
local n=string.lower(tool.Name)
for _,w in ipairs(SWORD_WORDS) do if n:find(w,1,true) then return "Sword" end end
return "Melee"
end
UIS.InputBegan:Connect(function(input)
if input.UserInputType==Enum.UserInputType.MouseButton1 then
lastKey="M1" lastKeyTime=os.clock()
return
end
local kn=input.KeyCode and input.KeyCode.Name
if kn and SKILL_KEYS[kn] then lastKey=kn lastKeyTime=os.clock() end
end)
function M.blocked()
if not enabled then return false end
local char=me.Character
local tool=char and char:FindFirstChildOfClass("Tool")
local f=flags[categoryOf(tool)]
if f.all then return true end
if lastKey and os.clock()-lastKeyTime<=1.5 and f[lastKey] then return true end
return false
end
function M.setEnabled(v) enabled=v end
function M.set(cat,key,v)
if flags[cat] then flags[cat][key]=v end
end
function M.reset()
for _,f in pairs(flags) do
for k in pairs(f) do f[k]=false end
end
end
return M
end)()
do local ok,err=pcall(function()do local p=pages["Blacklist"]local L,R=p.left,p.right local blT={}
title(L,"bl_title")
blT.enable=toggle(L,"bl_enable",nil,true,function(on)_G.SkillBL.setEnabled(on)end,true)
blT.mA=toggle(L,"bl_all_melee",nil,false,function(v)_G.SkillBL.set("Melee","all",v)end,false)
blT.mZ=toggle(L,"bl_melee_z",nil,false,function(v)_G.SkillBL.set("Melee","Z",v)end,false)
blT.mX=toggle(L,"bl_melee_x",nil,false,function(v)_G.SkillBL.set("Melee","X",v)end,false)
blT.mC=toggle(L,"bl_melee_c",nil,false,function(v)_G.SkillBL.set("Melee","C",v)end,false)
blT.fA=toggle(L,"bl_all_fruit",nil,false,function(v)_G.SkillBL.set("Fruit","all",v)end,false)
blT.fM1=toggle(L,"bl_fruit_m1",nil,false,function(v)_G.SkillBL.set("Fruit","M1",v)end,false)
blT.fZ=toggle(L,"bl_fruit_z",nil,false,function(v)_G.SkillBL.set("Fruit","Z",v)end,false)
blT.fX=toggle(L,"bl_fruit_x",nil,false,function(v)_G.SkillBL.set("Fruit","X",v)end,false)
blT.fC=toggle(L,"bl_fruit_c",nil,false,function(v)_G.SkillBL.set("Fruit","C",v)end,false)
blT.fV=toggle(L,"bl_fruit_v",nil,false,function(v)_G.SkillBL.set("Fruit","V",v)end,false)
blT.fF=toggle(L,"bl_fruit_f",nil,false,function(v)_G.SkillBL.set("Fruit","F",v)end,false)
blT.sA=toggle(R,"bl_all_sword",nil,false,function(v)_G.SkillBL.set("Sword","all",v)end,false)
blT.sZ=toggle(R,"bl_sword_z",nil,false,function(v)_G.SkillBL.set("Sword","Z",v)end,false)
blT.sX=toggle(R,"bl_sword_x",nil,false,function(v)_G.SkillBL.set("Sword","X",v)end,false)
blT.gA=toggle(R,"bl_all_gun",nil,false,function(v)_G.SkillBL.set("Gun","all",v)end,false)
blT.gZ=toggle(R,"bl_gun_z",nil,false,function(v)_G.SkillBL.set("Gun","Z",v)end,false)
blT.gX=toggle(R,"bl_gun_x",nil,false,function(v)_G.SkillBL.set("Gun","X",v)end,false)
blT.gM1=toggle(R,"bl_gun_m1",nil,false,function(v)_G.SkillBL.set("Gun","M1",v)end,false)
local rb=Instance.new("TextButton")rb.Size=UDim2.new(1,0,0,26)rb.BackgroundColor3=C.Surface rb.BackgroundTransparency=0.1 rb.BorderSizePixel=0 rb.Text=t("bl_reset")rb.TextColor3=C.White rb.Font=Enum.Font.FredokaOne rb.TextSize=11 rb.AutoButtonColor=false rb.ZIndex=3 rb.Parent=R round(rb,6)
rb.MouseButton1Click:Connect(function()_G.SkillBL.reset() for k,api in pairs(blT) do if k~="enable" and api and api.Set then api.Set(false) end end notify(t("notif_title"),t("bl_reset_done"),1.6) end)
updateCanvas(L)updateCanvas(R)end end) if not ok then warn("HardyWare pagina Blacklist: "..tostring(err)) end end
do local ok,err=pcall(function()
local p=pages["UI"] local L,R=p.left,p.right
title(L,"ui_scale")
slider(L,"ui_scale",hubScale,0.3,1.5,function(v)State.UserScaled=true applyScale(math.floor(v*100+0.5)/100)end)
end) if not ok then warn("HardyWare pagina UI: "..tostring(err)) end end
do local CONFIG_DIR="HardyWareConfigs"local AUTOLOAD_FILE=CONFIG_DIR.."/_autoload.txt"local function fs_isfolder(p)local ok,r=pcall(isfolder,p)return ok and r end local function fs_makefolder(p)pcall(makefolder,p)end local function fs_isfile(p)local ok,r=pcall(isfile,p)return ok and r end local function fs_readfile(p)local ok,r=pcall(readfile,p)if ok then return r end return nil end local function fs_writefile(p,c)return(pcall(writefile,p,c))end local function fs_delfile(p)pcall(delfile,p)end local function fs_listfiles(p)local ok,r=pcall(listfiles,p)if ok then return r end return{}end if not fs_isfolder(CONFIG_DIR)then fs_makefolder(CONFIG_DIR)end local function makeCard(parent,titleText)local card=Instance.new("Frame")card.Size=UDim2.new(1,0,0,0)card.AutomaticSize=Enum.AutomaticSize.Y card.BackgroundColor3=C.Header card.BackgroundTransparency=0.2 card.BorderSizePixel=0 card.ZIndex=2 card.Parent=parent round(card,8)line(card,C.Border,1,0.5)local pad=Instance.new("UIPadding")pad.PaddingTop=UDim.new(0,10)pad.PaddingBottom=UDim.new(0,10)pad.PaddingLeft=UDim.new(0,12)pad.PaddingRight=UDim.new(0,12)pad.Parent=card local layout=Instance.new("UIListLayout")layout.Padding=UDim.new(0,6)layout.SortOrder=Enum.SortOrder.LayoutOrder layout.Parent=card local title=Instance.new("TextLabel")title.Size=UDim2.new(1,0,0,16)title.BackgroundTransparency=1 title.Text=string.upper(t(titleText))title.TextColor3=C.Pink title.Font=Enum.Font.FredokaOne title.TextSize=11 title.TextXAlignment=Enum.TextXAlignment.Left title.LayoutOrder=-1 title.Parent=card table.insert(TransRegistry,{obj=title,key=titleText,prop="Text",suffix=""})local content=Instance.new("Frame")content.Size=UDim2.new(1,0,0,0)content.AutomaticSize=Enum.AutomaticSize.Y content.BackgroundTransparency=1 content.LayoutOrder=1 content.Parent=card local cLayout=Instance.new("UIListLayout")cLayout.Padding=UDim.new(0,4)cLayout.SortOrder=Enum.SortOrder.LayoutOrder cLayout.Parent=content return content end local function makeStyledButton(parent,keyText,bgColor,callback)local b=Instance.new("TextButton")b.Size=UDim2.new(1,0,0,26)b.BackgroundColor3=bgColor or C.Surface b.BackgroundTransparency=0.1 b.BorderSizePixel=0 b.Text=t(keyText)b.TextColor3=C.White b.Font=Enum.Font.FredokaOne b.TextSize=11 b.AutoButtonColor=false b.ZIndex=3 b.Parent=parent round(b,6)line(b,C.Border,1,0.4)b.MouseEnter:Connect(function()TweenService:Create(b,TweenInfo.new(0.1),{BackgroundTransparency=0}):Play()end)b.MouseLeave:Connect(function()TweenService:Create(b,TweenInfo.new(0.1),{BackgroundTransparency=0.1}):Play()end)b.MouseButton1Click:Connect(callback)table.insert(TransRegistry,{obj=b,key=keyText,prop="Text",suffix=""})return b end
local function collectConfig()local data={toggles={},sliders={},dropdowns={},inputs={},meta={version=1,savedAt=os.time()}}for id,obj in pairs(SaveRegistry.toggles)do pcall(function()data.toggles[id]={name=obj.name,value=obj.get()}end)end for id,obj in pairs(SaveRegistry.sliders)do pcall(function()data.sliders[id]={name=obj.name,value=obj.get()}end)end for id,obj in pairs(SaveRegistry.dropdowns)do pcall(function()data.dropdowns[id]={name=obj.name,value=obj.get()}end)end for id,obj in pairs(SaveRegistry.inputs)do pcall(function()data.inputs[id]={name=obj.name,value=obj.get()}end)end return data end
local function applyConfig(data)if type(data)~="table"then return false end if type(data.toggles)=="table"then for id,entry in pairs(data.toggles)do if SaveRegistry.toggles[id]and entry and entry.value~=nil then pcall(function()SaveRegistry.toggles[id].set(entry.value)end)end end end if type(data.sliders)=="table"then for id,entry in pairs(data.sliders)do if SaveRegistry.sliders[id]and entry and entry.value~=nil then pcall(function()SaveRegistry.sliders[id].set(entry.value)end)end end end if type(data.dropdowns)=="table"then for id,entry in pairs(data.dropdowns)do if SaveRegistry.dropdowns[id]and entry and entry.value~=nil then pcall(function()SaveRegistry.dropdowns[id].set(entry.value)end)end end end if type(data.inputs)=="table"then for id,entry in pairs(data.inputs)do if SaveRegistry.inputs[id]and entry and entry.value~=nil then pcall(function()SaveRegistry.inputs[id].set(entry.value)end)end end end return true end
local function sanitizeName(name)name=tostring(name or""):gsub("[^%w _%-]","")return(name:gsub("^%s*(.-)%s*$","%1"))end
local function saveConfig(name)name=sanitizeName(name)if name==""then notify(t("notif_title"),"Digite um nome para salvar",2)return false end local ok,encoded=pcall(function()return HttpService:JSONEncode(collectConfig())end)if not ok then notify(t("notif_title"),"Erro ao serializar",2)return false end if not fs_writefile(CONFIG_DIR.."/"..name..".json",encoded)then notify(t("notif_title"),"Erro ao salvar arquivo",2)return false end notify(t("notif_title"),"Salvo: "..name,2)return true end
local function loadConfig(name,silent)name=sanitizeName(name)local path=CONFIG_DIR.."/"..name..".json"if name==""or not fs_isfile(path)then if not silent then notify(t("notif_title"),"Config nao encontrado",2)end return false end local raw=fs_readfile(path)if not raw then return false end local ok,data=pcall(function()return HttpService:JSONDecode(raw)end)if not ok or not applyConfig(data)then notify(t("notif_title"),"Config corrompido",2)return false end if not silent then notify(t("notif_title"),"Carregado: "..name,2)end return true end
local function deleteConfig(name)name=sanitizeName(name)local path=CONFIG_DIR.."/"..name..".json"if name~=""and fs_isfile(path)then fs_delfile(path)notify(t("notif_title"),"Deletado: "..name,2)return true end return false end
local function listConfigs()local out={}for _,path in ipairs(fs_listfiles(CONFIG_DIR))do local file=path:match("([^/\\]+)%.json$")if file and file:sub(1,1)~="_"then table.insert(out,file)end end table.sort(out)return out end
local AutoSave={enabled=false,interval=10,lastSave=0,configName="_autosave"}local AutoLoad={enabled=false,configName=""}local lastSnapshot=""local function getSnapshot()local ok,enc=pcall(function()return HttpService:JSONEncode(collectConfig())end)return ok and enc or""end
task.spawn(function()lastSnapshot=getSnapshot()while true do task.wait(2)if AutoSave.enabled then local snap=getSnapshot()if snap~=lastSnapshot and snap~=""then lastSnapshot=snap if(tick()-AutoSave.lastSave)>=AutoSave.interval then AutoSave.lastSave=tick()local ok,enc=pcall(function()return HttpService:JSONEncode(collectConfig())end)if ok then fs_writefile(CONFIG_DIR.."/"..AutoSave.configName..".json",enc)end end end end end end)
local function unloadNeoWare()pcall(function()SilentAimModule:SetPlayerSilentAim(false)SilentAimModule:SetNPCSilentAim(false)SilentAimModule:SetSkillAimbot(false)SilentAimModule:SetPermanentCamLock(false)SilentAimModule:SetShowFOVCircle(false)SilentAimModule:SetTracerEnabled(false)SilentAimModule:SetSoruAutoAim(false)end)pcall(function()if _G.FastFlags then _G.FastFlags:restoreAll()end end)if AutoSave.enabled then local ok,enc=pcall(function()return HttpService:JSONEncode(collectConfig())end)if ok then fs_writefile(CONFIG_DIR.."/"..AutoSave.configName..".json",enc)end end pcall(function()State.flyActive=false State.speedBoost=false State.GlideEnabled=false State.DashLengthEnabled=false State.HitboxExpander=false State.AntiCombo=false State.AntiComboSkull=false State.AntiComboSoru=false State.InfiniteSoruEnabled=false State.AntiStunEnabled=false State.SkillSoruEnabled=false end)pcall(function()if player.Character then player.Character:SetAttribute("DashLength",1)player.Character:SetAttribute("DashLengthAir",1)player.Character:SetAttribute("FlashstepCooldown",0)player.Character:SetAttribute("Stun",0)end end)pcall(function()if HitboxExpander then HitboxExpander:Disable()end end)pcall(function()if _G.StopSpeedBoost then _G.StopSpeedBoost()end end)pcall(function()local char=player.Character local hum=char and char:FindFirstChildOfClass("Humanoid")if hum then hum.PlatformStand=false hum.WalkSpeed=16 hum.JumpPower=50 hum.UseJumpPower=true end end)pcall(function()for _,n in ipairs({"HardyWare","HardyWareHub","HardyWareNotifs","HardyWare_FOV"})do local e=guiParent:FindFirstChild(n)if e then e:Destroy()end end if gui then gui:Destroy()end end)pcall(function()blur:Destroy()end)pcall(function()if _G.FastAttackMod then _G.FastAttackMod:Toggle(false)end _G.FastAttackMod=nil end)pcall(function()if _G.KeyboardSoftener then _G.KeyboardSoftener:Disable()end _G.KeyboardSoftener=nil end)pcall(function()_G.SilentAimModule=nil _G.ESPModule=nil _G.M1Extender=nil _G.GunClickSL=nil _G.MobileJump=nil end)pcall(function()if FlyVel then FlyVel:Destroy()FlyVel=nil end end)end
local function closeScript()unloadNeoWare()pcall(function()if syn and syn.unload then syn.unload()end end)end
_G.__HardyWareUnload=unloadNeoWare
local p=pages["Config"]local L,R=p.left,p.right local LBox=makeCard(L,"Idioma")local langValues={}for code,name in pairs(LanguageNames)do table.insert(langValues,name)end table.sort(langValues)local langRow=Instance.new("Frame")langRow.Size=UDim2.new(1,0,0,24)langRow.BackgroundTransparency=1 langRow.Parent=LBox local langDesc=Instance.new("TextLabel")langDesc.Size=UDim2.new(1,0,0,18)langDesc.BackgroundTransparency=1 langDesc.Text=t("language_desc")langDesc.TextColor3=C.Muted langDesc.Font=Enum.Font.Gotham langDesc.TextSize=10 langDesc.TextXAlignment=Enum.TextXAlignment.Left langDesc.Parent=LBox table.insert(TransRegistry,{obj=langDesc,key="language_desc",prop="Text",suffix=""})dropdown(LBox,"Idioma",langValues,LanguageNames[CurrentLang]or"Portugues (BR)",function(selected)local newCode="pt"for code,name in pairs(LanguageNames)do if name==selected then newCode=code break end end if newCode~=CurrentLang then CurrentLang=newCode saveLang(CurrentLang)refreshAllTranslations()notify(t("notif_title"),t("language")..": "..selected,2)end end)local CBox=makeCard(L,"config_slots")local selectedConfig={value=nil}local nameInputHolder=Instance.new("Frame")nameInputHolder.Size=UDim2.new(1,0,0,26)nameInputHolder.BackgroundColor3=C.Bg nameInputHolder.BorderSizePixel=0 nameInputHolder.Parent=CBox round(nameInputHolder,6)line(nameInputHolder,C.Border,1,0.45)local nameInput=Instance.new("TextBox")nameInput.Size=UDim2.new(1,-10,1,0)nameInput.Position=UDim2.new(0,5,0,0)nameInput.BackgroundTransparency=1 nameInput.Text=""nameInput.PlaceholderText=t("placeholder_config")nameInput.TextColor3=C.White nameInput.PlaceholderColor3=C.Muted nameInput.Font=Enum.Font.Gotham nameInput.TextSize=11 nameInput.TextXAlignment=Enum.TextXAlignment.Left nameInput.ClearTextOnFocus=false nameInput.Parent=nameInputHolder table.insert(TransRegistry,{obj=nameInput,key="placeholder_config",prop="PlaceholderText",suffix=""})local ddHolder=Instance.new("TextButton")ddHolder.Size=UDim2.new(1,0,0,26)ddHolder.BackgroundColor3=C.Bg ddHolder.BorderSizePixel=0 ddHolder.Text=""ddHolder.AutoButtonColor=false ddHolder.Parent=CBox round(ddHolder,6)line(ddHolder,C.Border,1,0.45)local ddValue=Instance.new("TextLabel")ddValue.Size=UDim2.new(1,-10,1,0)ddValue.Position=UDim2.new(0,5,0,0)ddValue.BackgroundTransparency=1 ddValue.Text=t("nenhum")ddValue.TextColor3=C.Pink ddValue.Font=Enum.Font.Gotham ddValue.TextSize=11 ddValue.TextXAlignment=Enum.TextXAlignment.Left ddValue.Parent=ddHolder table.insert(TransRegistry,{obj=ddValue,key="nenhum",prop="Text",suffix=""})ddHolder.MouseButton1Click:Connect(function()local list=listConfigs()if#list==0 then notify(t("notif_title"),"Nenhum config salvo",2)return end local idx=1 if selectedConfig.value then for i,v in ipairs(list)do if v==selectedConfig.value then idx=i break end end idx=idx+1 if idx>#list then idx=1 end end selectedConfig.value=list[idx]ddValue.Text=selectedConfig.value end)makeStyledButton(CBox,"save_name",Color3.fromRGB(70,18,48),function()saveConfig(nameInput.Text)end)local btnRow1=Instance.new("Frame")btnRow1.Size=UDim2.new(1,0,0,26)btnRow1.BackgroundTransparency=1 btnRow1.Parent=CBox local r1Layout=Instance.new("UIListLayout")r1Layout.FillDirection=Enum.FillDirection.Horizontal r1Layout.Padding=UDim.new(0,4)r1Layout.Parent=btnRow1 local btnLoad=makeStyledButton(btnRow1,"load_selected",Color3.fromRGB(48,18,40),function()if selectedConfig.value then loadConfig(selectedConfig.value)else notify(t("notif_title"),"Nenhum config selecionado",2)end end)btnLoad.Size=UDim2.new(0.5,-2,1,0)local btnOverwrite=makeStyledButton(btnRow1,"overwrite",Color3.fromRGB(58,24,38),function()if selectedConfig.value then saveConfig(selectedConfig.value)else notify(t("notif_title"),"Nenhum config selecionado",2)end end)btnOverwrite.Size=UDim2.new(0.5,-2,1,0)local btnRow2=Instance.new("Frame")btnRow2.Size=UDim2.new(1,0,0,26)btnRow2.BackgroundTransparency=1 btnRow2.Parent=CBox local r2Layout=Instance.new("UIListLayout")r2Layout.FillDirection=Enum.FillDirection.Horizontal r2Layout.Padding=UDim.new(0,4)r2Layout.Parent=btnRow2 local btnDelete=makeStyledButton(btnRow2,"delete",Color3.fromRGB(65,35,35),function()if selectedConfig.value then deleteConfig(selectedConfig.value)selectedConfig.value=nil ddValue.Text=t("nenhum")else notify(t("notif_title"),"Nenhum config selecionado",2)end end)btnDelete.Size=UDim2.new(0.5,-2,1,0)local btnRefresh=makeStyledButton(btnRow2,"refresh_list",Color3.fromRGB(30,18,32),function()notify(t("notif_title"),#listConfigs().." config(s) encontrado(s)",2)end)btnRefresh.Size=UDim2.new(0.5,-2,1,0)local ASBox=makeCard(R,"auto_save")toggle(ASBox,"auto_save_toggle",nil,false,function(on)AutoSave.enabled=on end,true)slider(ASBox,"interval",10,3,60,function(v)AutoSave.interval=math.floor(v)end)local ALBox=makeCard(R,"auto_load")local autoLoadListHolder=Instance.new("TextButton")autoLoadListHolder.Size=UDim2.new(1,0,0,26)autoLoadListHolder.BackgroundColor3=C.Bg autoLoadListHolder.BorderSizePixel=0 autoLoadListHolder.Text=""autoLoadListHolder.AutoButtonColor=false autoLoadListHolder.Parent=ALBox round(autoLoadListHolder,6)line(autoLoadListHolder,C.Border,1,0.45)local alValue=Instance.new("TextLabel")alValue.Size=UDim2.new(1,-10,1,0)alValue.Position=UDim2.new(0,5,0,0)alValue.BackgroundTransparency=1 alValue.Text=t("nenhum")alValue.TextColor3=C.Pink alValue.Font=Enum.Font.Gotham alValue.TextSize=11 alValue.TextXAlignment=Enum.TextXAlignment.Left alValue.Parent=autoLoadListHolder table.insert(TransRegistry,{obj=alValue,key="nenhum",prop="Text",suffix=""})autoLoadListHolder.MouseButton1Click:Connect(function()local list=listConfigs()if#list==0 then notify(t("notif_title"),"Nenhum config salvo",2)return end local idx=1 if AutoLoad.configName~=""then for i,v in ipairs(list)do if v==AutoLoad.configName then idx=i break end end idx=idx+1 if idx>#list then idx=1 end end AutoLoad.configName=list[idx]alValue.Text=AutoLoad.configName end)local autoLoadToggle=toggle(ALBox,"auto_load_toggle",nil,false,function(on)AutoLoad.enabled=on if on and AutoLoad.configName~=""then fs_writefile(AUTOLOAD_FILE,AutoLoad.configName)elseif not on then fs_delfile(AUTOLOAD_FILE)end end,true)makeStyledButton(ALBox,"save_autoload",Color3.fromRGB(48,18,40),function()if AutoLoad.configName==""then notify(t("notif_title"),"Escolha um config primeiro",2)return end fs_writefile(AUTOLOAD_FILE,AutoLoad.configName)AutoLoad.enabled=true autoLoadToggle.Set(true)notify(t("notif_title"),"Auto-load salvo: "..AutoLoad.configName,2)end)local UBox=makeCard(R,"unload")makeStyledButton(UBox,"unload_dw",Color3.fromRGB(70,35,35),function()unloadNeoWare()end)makeStyledButton(UBox,"close_script",Color3.fromRGB(90,25,25),function()closeScript()end)task.spawn(function()task.wait(1.5)local savedAutoLoad=fs_readfile(AUTOLOAD_FILE)if savedAutoLoad and savedAutoLoad~=""then savedAutoLoad=sanitizeName(savedAutoLoad)if loadConfig(savedAutoLoad,true)then AutoLoad.configName=savedAutoLoad AutoLoad.enabled=true alValue.Text=savedAutoLoad autoLoadToggle.Set(true)notify(t("notif_title"),"Auto-load: "..savedAutoLoad,2.5)end end end)updateCanvas(L)updateCanvas(R)end
local function hookSoulGuitar(character)if not character then return end local function tryHook(child)if not child:IsA("Tool")then return end if string.find(child.Name,"Soul")or string.find(child.Name,"Guitar")or string.find(child.Name,"soul")or string.find(child.Name,"guitar")then child.Activated:Connect(function()if not State.GlideEnabled then return end State.LastShootTime=tick()end)end end for _,child in ipairs(character:GetChildren())do tryHook(child)end character.ChildAdded:Connect(tryHook)end
if player.Character then hookSoulGuitar(player.Character)end
player.CharacterAdded:Connect(hookSoulGuitar)
local SpeedBoostConn=nil
local SpeedBoostEnabled=false
local SpeedBoostChar=nil
local SpeedBoostHum=nil
local SpeedBoostHRP=nil
local SpeedBoostTool=nil
local SpeedBoostHolding=nil
local SpeedBoostHoldConn=nil
local function speedBoostDetach()if SpeedBoostHoldConn then pcall(function()SpeedBoostHoldConn:Disconnect()end)SpeedBoostHoldConn=nil end SpeedBoostChar,SpeedBoostHum,SpeedBoostHRP=nil,nil,nil SpeedBoostTool,SpeedBoostHolding=nil,nil end
local function isInSkillMove()if SpeedBoostHolding and SpeedBoostHolding.Parent and SpeedBoostHolding.Value==true then return true end if GlitchV2 and GlitchV2.S then local hum=SpeedBoostHum if hum and hum.PlatformStand==true then return true end end if _G.__HardyWareSoulGuitarBoostActive==true then return true end if _G.__HardyWareDiamondBoostActive==true then return true end return false end
local function speedBoostBind(character)speedBoostDetach()if not character then return end SpeedBoostChar=character SpeedBoostHum=character:FindFirstChildOfClass("Humanoid")SpeedBoostHRP=character:FindFirstChild("HumanoidRootPart")SpeedBoostTool=character:FindFirstChildOfClass("Tool")SpeedBoostHolding=SpeedBoostTool and SpeedBoostTool:FindFirstChild("Holding")or nil SpeedBoostHoldConn=character.ChildAdded:Connect(function(c)if c:IsA("Tool")then SpeedBoostTool=c SpeedBoostHolding=c:FindFirstChild("Holding")end end)if SpeedBoostHum then SpeedBoostHum.Died:Connect(function()speedBoostDetach()end)end end
local function speedBoostTick(dt)if not SpeedBoostEnabled then return end local char=SpeedBoostChar if not char or not char.Parent then speedBoostBind(player.Character)char=SpeedBoostChar if not char then return end end local hum=SpeedBoostHum local hrp=SpeedBoostHRP if not hum or not hrp or not hrp.Parent or hum.Health<=0 then return end if isInSkillMove()then return end local st=hum:GetState()if hum.Sit or hum.SeatPart~=nil or st==Enum.HumanoidStateType.Seated or st==Enum.HumanoidStateType.GettingUp or st==Enum.HumanoidStateType.Dead then return end local dir=hum.MoveDirection if dir.Magnitude>0.01 then local q=math.clamp((tonumber(dt)or(1/60))*60,0.25,2)local speedValue=tonumber(State.speedValue)or 2 hrp.CFrame=hrp.CFrame+dir*speedValue*0.5*q end end
function _G.SetSpeedBoost(on)if on==SpeedBoostEnabled then return end SpeedBoostEnabled=on==true if SpeedBoostEnabled then speedBoostBind(player.Character)if not SpeedBoostConn then SpeedBoostConn=RunService.Heartbeat:Connect(speedBoostTick)end else if SpeedBoostConn then SpeedBoostConn:Disconnect()SpeedBoostConn=nil end speedBoostDetach()end end
_G.StopSpeedBoost=function()_G.SetSpeedBoost(false)end
player.CharacterAdded:Connect(function(c)if SpeedBoostEnabled then speedBoostBind(c)end end)
RunService.RenderStepped:Connect(function()if State.flyActive then local char=player.Character local root=char and char:FindFirstChild("HumanoidRootPart")if root then if not FlyVel or FlyVel.Parent~=root then if FlyVel then FlyVel:Destroy()end FlyVel=Instance.new("BodyVelocity")FlyVel.Name="SkyFly"FlyVel.MaxForce=Vector3.new(9e9,9e9,9e9)FlyVel.Parent=root end local md=Vector3.zero if UserInputService:IsKeyDown(KC_W)then md=md+camera.CFrame.LookVector end if UserInputService:IsKeyDown(KC_S)then md=md-camera.CFrame.LookVector end if UserInputService:IsKeyDown(KC_A)then md=md-camera.CFrame.RightVector end if UserInputService:IsKeyDown(KC_D)then md=md+camera.CFrame.RightVector end FlyVel.Velocity=md*State.flySpeed end end end)
task.spawn(function()while true do task.wait(0.1)if State.GlideEnabled then local char=player.Character if char then local hrp=char:FindFirstChild("HumanoidRootPart")local hum=char:FindFirstChildOfClass("Humanoid")if hrp and hum then if(tick()-State.LastShootTime<1.5)and hrp.Velocity.Magnitude>20 then if hrp:FindFirstChild("OmniGlide")then hrp.OmniGlide:Destroy()end local CurrentBV=Instance.new("BodyVelocity")CurrentBV.Name="OmniGlide"CurrentBV.MaxForce=Vector3.new(100000,0,100000)local Dir=hum.MoveDirection if Dir.Magnitude==0 then local cl=camera.CFrame.LookVector Dir=Vector3.new(cl.X,0,cl.Z).Unit else Dir=Dir.Unit end CurrentBV.Velocity=Dir*State.GlideSpeed CurrentBV.Parent=hrp Debris:AddItem(CurrentBV,State.GlideTime)State.LastShootTime=0 end end end end end end)
task.spawn(function()while true do task.wait(0.1)if State.DashLengthEnabled then local char=player.Character if char then local currentLen=char:GetAttribute("DashLength")if currentLen~=State.DashLengthValue then char:SetAttribute("DashLength",State.DashLengthValue)char:SetAttribute("DashLengthAir",State.DashLengthValue)end end end end end)
HitboxExpander=(function()local module={}local active=false local tracked=setmetatable({},{__mode="k"})local visuals=setmetatable({},{__mode="k"})local connections=setmetatable({},{__mode="k"})local charConnections={}
local function getPlayerFromChar(char)return Players:GetPlayerFromCharacter(char)end
local function isEnemy(tp)if not tp or tp==player then return false end local myT,tT=player.Team,tp.Team if myT and tT then local mn,tn=myT.Name,tT.Name if mn=="Pirates" and tn=="Marines" then return true end if mn=="Marines" and tn=="Pirates" then return true end if mn=="Pirates" and tn=="Pirates" then return true end if mn=="Marines" and tn=="Marines" then return false end end return true end
local function shouldExpand(model)if not active then return false end if not model or not model:IsA("Model")or model==player.Character then return false end local plr=getPlayerFromChar(model)if plr then return isEnemy(plr)end return State.HitboxNPCs and model.Parent==workspace:FindFirstChild("Enemies")end
local function restore(model,head)if not tracked[head]then return end local data=tracked[head]if visuals[head]then visuals[head]:Destroy()visuals[head]=nil end if data.connections then for _,c in ipairs(data.connections)do pcall(function()c:Disconnect()end)end end head.Size=data.Size head.Transparency=data.Transparency head.CanCollide=data.CanCollide head.Massless=data.Massless tracked[head]=nil end
local function apply(model,head)if not shouldExpand(model)or not head then return end if tracked[head]then return end tracked[head]={Size=head.Size,Transparency=head.Transparency,CanCollide=head.CanCollide,Massless=head.Massless,connections={}}local sizeVal=State.HitboxSize head.Size=Vector3.new(sizeVal,sizeVal,sizeVal)head.Transparency=1 head.CanCollide=false head.Massless=true if State.HitboxVisual then local box=Instance.new("SelectionBox")box.Color3=Color3.new(1,1,1)box.SurfaceColor3=Color3.fromRGB(13,105,172)box.LineThickness=0.05 box.SurfaceTransparency=1 box.Adornee=head box.Parent=workspace visuals[head]=box end local function onChanged()if tracked[head]and active then local s=State.HitboxSize if head.Size~=Vector3.new(s,s,s)or head.Transparency~=1 or head.CanCollide~=false then task.defer(function()if tracked[head]then apply(model,head)end end)end end end table.insert(tracked[head].connections,head:GetPropertyChangedSignal("Size"):Connect(onChanged))table.insert(tracked[head].connections,head:GetPropertyChangedSignal("Transparency"):Connect(onChanged))table.insert(tracked[head].connections,head:GetPropertyChangedSignal("CanCollide"):Connect(onChanged))end
local function trackModel(model)if not model or not model:IsA("Model")or model==player.Character or connections[model]then return end local head=model:FindFirstChild("Head")if head then if shouldExpand(model)then apply(model,head)end end local conn=model.ChildAdded:Connect(function(child)if child.Name=="Head"and child:IsA("BasePart")then task.defer(function()if shouldExpand(model)then apply(model,child)end end)end end)connections[model]=conn end
local function untrackModel(model)if not model then return end local head=model:FindFirstChild("Head")if head then restore(model,head)end if connections[model]then connections[model]:Disconnect()connections[model]=nil end end
function module:Refresh()for model,conn in pairs(connections)do untrackModel(model)end for head,data in pairs(tracked)do local model=head.Parent if model then restore(model,head)end end if not active then return end for _,plr in ipairs(Players:GetPlayers())do if plr~=player and plr.Character then trackModel(plr.Character)end end local enemies=workspace:FindFirstChild("Enemies")if enemies then for _,model in ipairs(enemies:GetChildren())do trackModel(model)end end end
function module:Enable()if active then return end active=true for _,plr in ipairs(Players:GetPlayers())do if plr~=player then local c=plr.CharacterAdded:Connect(function(char)task.wait(0.3)trackModel(char)end)table.insert(charConnections,c)if plr.Character then trackModel(plr.Character)end end end local enemies=workspace:FindFirstChild("Enemies")if enemies then local c=enemies.ChildAdded:Connect(function(model)task.wait(0.2)trackModel(model)end)table.insert(charConnections,c)local c2=enemies.ChildRemoved:Connect(function(model)untrackModel(model)end)table.insert(charConnections,c2)for _,model in ipairs(enemies:GetChildren())do trackModel(model)end end local c3=player.CharacterAdded:Connect(function()task.wait(1)self:Refresh()end)table.insert(charConnections,c3)self:Refresh()end
function module:Disable()if not active then return end active=false for _,c in ipairs(charConnections)do pcall(function()c:Disconnect()end)end charConnections={}for model,conn in pairs(connections)do untrackModel(model)end for head,data in pairs(tracked)do local model=head.Parent if model then restore(model,head)end end end
return module end)()
AntiCombo=(function()local module={}local active=false local lastAttempt=0 local escapeMethod=nil local aimRoot=nil local aimUntil=0 local casting=false local lastHealth=nil local damageTimes={}local escapeUntil=0 local attempts=0 local soruStart=nil local soruBaselineSet=false
local function getPortalTool(char)local function isPortal(tool)if not tool or not tool:IsA("Tool")then return false end local name=string.lower(tool.Name):gsub("[%s_%-]","")return name=="portal"or name=="portalportal"end local tool=char and char:FindFirstChildOfClass("Tool")if isPortal(tool)then return tool end local backpack=player:FindFirstChildOfClass("Backpack")or player:FindFirstChild("Backpack")if backpack then for _,child in ipairs(backpack:GetChildren())do if isPortal(child)then return child end end end return nil end
local function getSkullTool(char)local function isSkull(tool)if not tool or not tool:IsA("Tool")then return false end local name=string.lower(tool.Name):gsub("[%s_%-]","")return name=="skullguitar"or name=="soulguitar"end local tool=char and char:FindFirstChildOfClass("Tool")if isSkull(tool)then return tool end local backpack=player:FindFirstChildOfClass("Backpack")or player:FindFirstChild("Backpack")if backpack then for _,child in ipairs(backpack:GetChildren())do if isSkull(child)then return child end end end return nil end
local function getPortalXCooldown()local pg=player:FindFirstChild("PlayerGui")local main=pg and pg:FindFirstChild("Main")local skills=main and main:FindFirstChild("Skills")local portal=skills and(skills:FindFirstChild("Portal")or skills:FindFirstChild("Portal-Portal"))local x=portal and portal:FindFirstChild("X")return x and x:FindFirstChild("Cooldown")end
local function portalXOnCooldown()local cd=getPortalXCooldown()return cd and cd.Visible==true and cd.Size.X.Scale>0.05 end
local function getSkullXCooldown()local pg=player:FindFirstChild("PlayerGui")local main=pg and pg:FindFirstChild("Main")local skills=main and main:FindFirstChild("Skills")local skull=skills and(skills:FindFirstChild("Skull Guitar")or skills:FindFirstChild("Soul Guitar"))local x=skull and skull:FindFirstChild("X")return x and x:FindFirstChild("Cooldown")end
local function skullXOnCooldown()local cd=getSkullXCooldown()return cd and cd.Visible==true and cd.Size.X.Scale>0.05 end
local function sendPortalX(char,tool)if casting then return end casting=true task.spawn(function()pcall(function()local hum=char and char:FindFirstChildOfClass("Humanoid")if hum and tool and tool.Parent~=char then hum:EquipTool(tool)task.wait(0.025)end local VirtualInputManager=game:GetService("VirtualInputManager")VirtualInputManager:SendKeyEvent(true,Enum.KeyCode.X,false,game)task.wait(0.035)VirtualInputManager:SendKeyEvent(false,Enum.KeyCode.X,false,game)end)task.wait(0.025)casting=false end)end
local function sendSkullX(char,tool)if casting then return end casting=true aimRoot=char and char:FindFirstChild("HumanoidRootPart")aimUntil=tick()+1.6 task.spawn(function()pcall(function()local hum=char and char:FindFirstChildOfClass("Humanoid")if hum and tool and tool.Parent~=char then hum:EquipTool(tool)task.wait(0.025)end local VirtualInputManager=game:GetService("VirtualInputManager")VirtualInputManager:SendKeyEvent(true,Enum.KeyCode.X,false,game)task.wait(0.035)VirtualInputManager:SendKeyEvent(false,Enum.KeyCode.X,false,game)end)task.wait(0.025)casting=false end)end
local function trimDamage(now)while damageTimes[1]do if now-damageTimes[1].time>1.15 then table.remove(damageTimes,1)else break end end end
local function comboDetected(char)trimDamage(tick())local stun=char:FindFirstChild("Stun")local isStunned=stun and tonumber(stun.Value)and tonumber(stun.Value)>0 local totalDmg=0 for _,entry in ipairs(damageTimes)do totalDmg=totalDmg+(entry.amount or 0)end local count=#damageTimes local hum=char:FindFirstChildOfClass("Humanoid")local maxHP=hum and math.max(hum.MaxHealth,1)or 100 local isDmg=count>=3 and totalDmg>=math.max(250,maxHP*0.025)local isStun=isStunned and count>=2 and totalDmg>=math.max(500,maxHP*0.045)return isDmg or isStun end
local function beginSoruFallback(char)if not State.AntiComboSoru then escapeUntil=0 damageTimes={}return false end escapeMethod="Soru"soruStart=char and char:GetAttribute("LastSoru")or nil soruBaselineSet=true lastAttempt=0 attempts=0 escapeUntil=math.max(escapeUntil,tick()+2)return true end
local function attempt(char)local now=tick()if now>=escapeUntil then return false end local portal=State.AntiCombo and getPortalTool(char)or nil local skull=State.AntiComboSkull and getSkullTool(char)or nil local method=escapeMethod if method=="Portal"and portalXOnCooldown()then escapeUntil=0 damageTimes={}return false elseif method=="Skull"and skullXOnCooldown()then escapeUntil=0 damageTimes={}aimRoot=nil aimUntil=0 return false end if method==nil then if portal and not portalXOnCooldown()then escapeMethod="Portal"else if not beginSoruFallback(char)then return false end end elseif method=="Portal"and(not portal or portalXOnCooldown())then if not beginSoruFallback(char)then return false end elseif method=="Skull"and(not skull or skullXOnCooldown())then if not beginSoruFallback(char)then return false end end if casting or now-lastAttempt<0.07 then return true end if escapeMethod=="Portal"and portal then lastAttempt=now attempts=attempts+1 sendPortalX(char,portal)return true end if escapeMethod=="Skull"and skull then aimRoot=char and char:FindFirstChild("HumanoidRootPart")aimUntil=now+1.6 lastAttempt=now attempts=attempts+1 sendSkullX(char,skull)return true end if escapeMethod=="Soru"then if not State.AntiComboSoru then escapeUntil=0 damageTimes={}return false end local lastSoru=char:GetAttribute("LastSoru")if soruBaselineSet and lastSoru~=nil and lastSoru~=soruStart then escapeUntil=0 damageTimes={}return false end lastAttempt=now attempts=attempts+1 local VirtualInputManager=game:GetService("VirtualInputManager")pcall(function()VirtualInputManager:SendKeyEvent(true,Enum.KeyCode.R,false,game)task.wait(0.04)VirtualInputManager:SendKeyEvent(false,Enum.KeyCode.R,false,game)end)return true end return false end
local function startWorker(char)task.spawn(function()while active and escapeUntil>tick()do if not attempt(char)then break end task.wait(0.012)end end)end
local function evaluate(char)if not active or char~=player.Character then return end local hum=char and char:FindFirstChildOfClass("Humanoid")if not hum or hum.Health<=0 or not comboDetected(char)then return end local now=tick()if now>=escapeUntil then attempts=0 escapeMethod=nil soruStart=char:GetAttribute("LastSoru")soruBaselineSet=true end escapeUntil=now+2.4 startWorker(char)end
local function bindCharacter(char)lastHealth=nil damageTimes={}escapeUntil=0 if not char then return end local hum=char:FindFirstChildOfClass("Humanoid")or char:WaitForChild("Humanoid",5)if not hum then return end lastHealth=hum.Health hum.HealthChanged:Connect(function(hp)if char~=player.Character then return end local old=lastHealth or hp lastHealth=hp if hp<old-0.5 then table.insert(damageTimes,{time=tick(),amount=old-hp})evaluate(char)task.delay(0.025,function()evaluate(char)end)end end)local stun=char:FindFirstChild("Stun")if stun then stun.Changed:Connect(function()evaluate(char)end)end char.ChildAdded:Connect(function(child)if child.Name=="Stun"then child.Changed:Connect(function()evaluate(char)end)end end)end
function module:Enable()if active then return end active=true bindCharacter(player.Character)player.CharacterAdded:Connect(bindCharacter)end
function module:Disable()if not active then return end active=false damageTimes={}escapeUntil=0 escapeMethod=nil end
return module end)()
local function ResetJump()local char=player.Character local hum=char and char:FindFirstChild("Humanoid")if hum then hum.JumpPower=50 hum.UseJumpPower=true end end
ResetJump()
player.CharacterAdded:Connect(ResetJump)
UserInputService.InputBegan:Connect(function(input,gp)local kc=input.KeyCode if gp and kc~=Enum.KeyCode.L then return end if UserInputService:GetFocusedTextBox()then return end if kc==Enum.KeyCode.LeftControl or kc==Enum.KeyCode.F2 then toggleHub()elseif kc==Enum.KeyCode.G then local char=player.Character local hrp=char and char:FindFirstChild("HumanoidRootPart")local hum=char and char:FindFirstChildOfClass("Humanoid")if hrp and hum and hum.Health>0 then local currentVel=hrp.AssemblyLinearVelocity hrp.AssemblyLinearVelocity=Vector3.new(currentVel.X,State.JumpForce,currentVel.Z)if hum:GetState()~=Enum.HumanoidStateType.Freefall then hum:ChangeState(Enum.HumanoidStateType.Jumping)end end elseif kc==Enum.KeyCode.L then local ok,msg=SilentAimModule:ToggleTargetLock()if targetLockToggle then targetLockToggle.Set(ok)end notify(t("target_lock"),msg,1.5)end end)
player.CharacterAdded:Connect(function(char)if State.DashLengthEnabled then task.wait(0.2)char:SetAttribute("DashLength",State.DashLengthValue)char:SetAttribute("DashLengthAir",State.DashLengthValue)end if State.HitboxExpander then task.wait(1)HitboxExpander:Refresh()end end)
-- [REMOVED: StreamProof]
-- [REMOVED: Stream page]
task.spawn(function()
	task.wait(0.2)
	ToggleButton.Visible=true
	mobileJumpBtn.Visible=false
	showPage("PVP")
	setHub(true)
	notify(t("notif_title"),t("loaded").." (HardyWare)",4)
end)
end,function(err)warn("ERRO NO HardyWare: "..tostring(err))end)