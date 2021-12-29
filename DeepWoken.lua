local camera = game:GetService("Workspace").CurrentCamera
local currentCamera = workspace.CurrentCamera
local worldToViewportPoint = currentCamera.worldToViewportPoint

local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
on = false
player_on = false
range = 500
--SETUP Menu
local menu_toggle = Drawing.new("Text")
menu_toggle.Text = "Mob ESP: OFF"
menu_toggle.Color = Color3.new(255/255,255/255,255/255)
menu_toggle.Position = Vector2.new(80,900)
menu_toggle.Size = 20.0
menu_toggle.Outline = true
menu_toggle.Center = false
menu_toggle.Visible = true
local menu_toggle2 = Drawing.new("Text")
menu_toggle2.Text = "Player ESP: OFF"
menu_toggle2.Color = Color3.new(255/255,255/255,255/255)
menu_toggle2.Position = Vector2.new(80,920)
menu_toggle2.Size = 20.0
menu_toggle2.Outline = true
menu_toggle2.Center = false
menu_toggle2.Visible = true
local menu_toggle3 = Drawing.new("Text")
menu_toggle3.Text = "ESP Range: 500"
menu_toggle3.Color = Color3.new(255/255,255/255,255/255)
menu_toggle3.Position = Vector2.new(80,940)
menu_toggle3.Size = 20.0
menu_toggle3.Outline = true
menu_toggle3.Center = false
menu_toggle3.Visible = true

-- Settings


-- Script

mouse.KeyDown:connect(function(key)
if key == bind then
    if on then 
      on = false
      menu_toggle.Text = "Mob ESP: OFF"
    else
      on = true
      menu_toggle.Text = "Mob ESP: ON"
    end
end
if key == player_bind then
    if player_on then 
      player_on = false 
      menu_toggle2.Text = "Player ESP: OFF"
    else
      player_on = true
      menu_toggle2.Text = "Player ESP: ON"
    end
end
if key == range_up then
      range = math.clamp(range + 25, 0, 2000)
      menu_toggle3.Text = "ESP Range: " .. range
    end
end
if key == range_down then
      range = math.clamp(range - 25, 0, 2000)
      menu_toggle3.Text = "ESP Range: " .. range
    end
end
end)
function WTS(part, pos)
local screen = workspace.CurrentCamera:WorldToViewportPoint(part.Position + Vector3.new(0, pos, 0))

return Vector2.new(screen.x, screen.y)
end

function ESPText(part, color)
  local name = Drawing.new("Text")
  name.Text = part.Parent.Name
  name.Color = color
  name.Position = WTS(part, 3)
  name.Size = 20.0
  name.Outline = true
  name.Center = true
  name.Visible = true

  local tracer = Drawing.new("Line")
  tracer.Visible = false
  tracer.Color = Color3.new(1,1,1)
  tracer.Thickness = 1
  tracer.Transparency = 1

  game:GetService("RunService").Stepped:connect(function()
    pcall(function()
      local destroyed = not part:IsDescendantOf(workspace)
      if destroyed and name ~= nil then
        name:Remove()
        tracer:Remove()
      end
      if part ~= nil then
        name.Position = WTS(part, 3)
        name.Text = math.floor(part.Parent.Humanoid.Health) .. "/" .. part.Parent.Humanoid.MaxHealth
      end
      local Vector, screen = workspace.CurrentCamera:WorldToViewportPoint(part.Position)
      mag = (part.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude
      if screen and mag < range and on == true and part.Parent:FindFirstChild("Target") then
        name.Visible = true
        tracer.Visible = true
        tracer.From = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
        tracer.To = Vector2.new(Vector.X, Vector.Y)
      elseif screen and mag < range and player_on == true and not part.Parent:FindFirstChild("Target") then
        name.Visible = true
        tracer.Visible = true
        tracer.From = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
        tracer.To = Vector2.new(Vector.X, Vector.Y)
      else
        tracer.Visible = false
        name.Visible = false
      end
    end)
  end)
end

local entity = game.Workspace.Live:getChildren()
  for i=1,#entity do
      pcall(function()
    if entity[i].HumanoidRootPart ~= game.Players.LocalPlayer.Character.HumanoidRootPart then
      if entity[i]:findFirstChild("HumanoidRootPart") then
        if entity[i]:FindFirstChild("Target") then
          ESPText(entity[i].HumanoidRootPart, Color3.new(255/255,100/255,100/255))
        else
          ESPText(entity[i].HumanoidRootPart, Color3.new(100/255,100/255,255/255))
      end
    end
    end
    end)
end

game.Workspace.Live.ChildAdded:Connect(function(child)
    if child:WaitForChild("HumanoidRootPart") then
      if child:FindFirstChild("Target") then
        ESPText(child.HumanoidRootPart, Color3.new(255/255,100/255,100/255))
      else
        ESPText(child.HumanoidRootPart, Color3.new(100/255,100/255,255/255))
      end
    end
end)


