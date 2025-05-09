-- Mobile-Compatible Kavo UI (Optimized with Multiple Themes)
local Library = {}

local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")

-- Theme color definitions
local Themes = {
    Midnight = {
        Background = Color3.fromRGB(10, 10, 20),
        ButtonBackground = Color3.fromRGB(30, 30, 40),
        ButtonText = Color3.fromRGB(255, 255, 255),
        Text = Color3.fromRGB(255, 255, 255)
    },
    Ocean = {
        Background = Color3.fromRGB(0, 50, 75),
        ButtonBackground = Color3.fromRGB(0, 100, 150),
        ButtonText = Color3.fromRGB(255, 255, 255),
        Text = Color3.fromRGB(255, 255, 255)
    },
    Night = {
        Background = Color3.fromRGB(30, 30, 30),
        ButtonBackground = Color3.fromRGB(50, 50, 50),
        ButtonText = Color3.fromRGB(255, 255, 255),
        Text = Color3.fromRGB(255, 255, 255)
    },
    Light = {
        Background = Color3.fromRGB(255, 255, 255),
        ButtonBackground = Color3.fromRGB(230, 230, 230),
        ButtonText = Color3.fromRGB(0, 0, 0),
        Text = Color3.fromRGB(0, 0, 0)
    },
    Synapse = {
        Background = Color3.fromRGB(0, 20, 40),
        ButtonBackground = Color3.fromRGB(20, 40, 80),
        ButtonText = Color3.fromRGB(255, 255, 255),
        Text = Color3.fromRGB(255, 255, 255)
    },
    Dark = {
        Background = Color3.fromRGB(30, 30, 30),
        ButtonBackground = Color3.fromRGB(50, 50, 50),
        ButtonText = Color3.fromRGB(255, 255, 255),
        Text = Color3.fromRGB(255, 255, 255)
    },
    Blood = {
        Background = Color3.fromRGB(80, 10, 10),
        ButtonBackground = Color3.fromRGB(120, 20, 20),
        ButtonText = Color3.fromRGB(255, 255, 255),
        Text = Color3.fromRGB(255, 255, 255)
    }
}

-- Simple UI base
function Library.CreateLib(title, theme)
    local themeColors = Themes[theme] or Themes.Night  -- Default to Night theme if not found
    local ScreenGui = Instance.new("ScreenGui", CoreGui)
    ScreenGui.Name = "MobileKavoUI"
    ScreenGui.ResetOnSpawn = false

    local MainFrame = Instance.new("Frame", ScreenGui)
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 500, 0, 350)
    MainFrame.Position = UDim2.new(0.5, -250, 0.5, -175)
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.BackgroundColor3 = themeColors.Background
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.Draggable = true

    local TabHolder = Instance.new("Frame", MainFrame)
    TabHolder.Size = UDim2.new(0, 120, 1, 0)
    TabHolder.BackgroundColor3 = themeColors.ButtonBackground

    local PageContainer = Instance.new("Frame", MainFrame)
    PageContainer.Position = UDim2.new(0, 120, 0, 0)
    PageContainer.Size = UDim2.new(1, -120, 1, 0)
    PageContainer.BackgroundTransparency = 1

    local Tabs = {}
    local Pages = {}

    function Library:ToggleUI()
        ScreenGui.Enabled = not ScreenGui.Enabled
    end

    function Library:Notify(title, text, time)
        local Notify = Instance.new("TextLabel", ScreenGui)
        Notify.Text = title .. ": " .. text
        Notify.Size = UDim2.new(0, 300, 0, 50)
        Notify.Position = UDim2.new(0.5, -150, 0, -60)
        Notify.BackgroundColor3 = themeColors.ButtonBackground
        Notify.TextColor3 = themeColors.Text
        Notify.TextScaled = true
        Notify.BorderSizePixel = 0

        local tween = TweenService:Create(Notify, TweenInfo.new(0.3), {Position = UDim2.new(0.5, -150, 0, 20)})
        tween:Play()
        wait(time or 3)
        Notify:Destroy()
    end

    function Library:NewTab(name)
        local TabButton = Instance.new("TextButton", TabHolder)
        TabButton.Text = name
        TabButton.Size = UDim2.new(1, 0, 0, 30)
        TabButton.BackgroundColor3 = themeColors.ButtonBackground
        TabButton.TextColor3 = themeColors.ButtonText
        TabButton.BorderSizePixel = 0

        local Page = Instance.new("ScrollingFrame", PageContainer)
        Page.Name = name .. "Page"
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.CanvasSize = UDim2.new(0, 0, 10, 0)
        Page.BackgroundTransparency = 1
        Page.Visible = false
        Page.ScrollBarThickness = 4

        TabButton.MouseButton1Click:Connect(function()
            for _, v in pairs(PageContainer:GetChildren()) do
                if v:IsA("ScrollingFrame") then
                    v.Visible = false
                end
            end
            Page.Visible = true
        end)

        Page.Visible = #Pages == 0

        local SectionList = {}

        local TabObject = {}
        function TabObject:NewSection(name)
            local Section = Instance.new("Frame", Page)
            Section.Size = UDim2.new(1, -10, 0, 200)
            Section.Position = UDim2.new(0, 5, 0, (#SectionList * 210) + 10)
            Section.BackgroundColor3 = themeColors.ButtonBackground
            Section.BorderSizePixel = 0

            local UIList = Instance.new("UIListLayout", Section)
            UIList.Padding = UDim.new(0, 6)

            table.insert(SectionList, Section)

            local SectionObj = {}

            function SectionObj:NewSlider(name, desc, max, min, callback)
                local Slider = Instance.new("TextButton", Section)
                Slider.Text = name
                Slider.Size = UDim2.new(1, -10, 0, 40)
                Slider.BackgroundColor3 = themeColors.ButtonBackground
                Slider.TextColor3 = themeColors.ButtonText
                Slider.BorderSizePixel = 0

                Slider.MouseButton1Click:Connect(function()
                    local val = tonumber(string.match(game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("Chat"):GetChildren()[1].Text, "%d+"))
                    if val then callback(val) end
                end)
            end

            function SectionObj:NewButton(name, callback)
                local Btn = Instance.new("TextButton", Section)
                Btn.Text = name
                Btn.Size = UDim2.new(1, -10, 0, 40)
                Btn.BackgroundColor3 = themeColors.ButtonBackground
                Btn.TextColor3 = themeColors.ButtonText
                Btn.BorderSizePixel = 0
                Btn.MouseButton1Click:Connect(callback)
            end

            function SectionObj:NewToggle(name, desc, default, callback)
                local Toggle = Instance.new("TextButton", Section)
                Toggle.Text = name .. ": OFF"
                Toggle.Size = UDim2.new(1, -10, 0, 40)
                Toggle.BackgroundColor3 = themeColors.ButtonBackground
                Toggle.TextColor3 = themeColors.ButtonText
                Toggle.BorderSizePixel = 0
                local on = default

                Toggle.MouseButton1Click:Connect(function()
                    on = not on
                    Toggle.Text = name .. ": " .. (on and "ON" or "OFF")
                    callback(on)
                end)
            end

            function SectionObj:NewTextbox(name, placeholder, callback)
                local TextBox = Instance.new("TextBox", Section)
                TextBox.PlaceholderText = placeholder
                TextBox.Text = ""
                TextBox.Size = UDim2.new(1, -10, 0, 40)
                TextBox.BackgroundColor3 = themeColors.ButtonBackground
                TextBox.TextColor3 = themeColors.ButtonText
                TextBox.BorderSizePixel = 0
                TextBox.FocusLost:Connect(function()
                    callback(TextBox.Text)
                end)
            end

            function SectionObj:NewDropdown(name, desc, list, callback)
                local Drop = Instance.new("TextButton", Section)
                Drop.Text = name .. " (Click)"
                Drop.Size = UDim2.new(1, -10, 0, 40)
                Drop.BackgroundColor3 = themeColors.ButtonBackground
                Drop.TextColor3 = themeColors.ButtonText
                Drop.BorderSizePixel = 0

                Drop.MouseButton1Click:Connect(function()
                    callback(list[1])
                end)
            end

            return SectionObj
        end

        return TabObject
    end

    return Library
end

return Library

