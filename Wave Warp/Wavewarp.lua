-- Wave Warp Script for Aseprite By AyItzmatt :3

local sprite = app.activeSprite
if not sprite then return app.alert("No active sprite found!") end

    local layer = app.activeLayer
    if not layer or layer.isBackground then
        return app.alert("Please select a transparent layer, not the Background!")
        end

        local firstFrame = app.activeFrame
        local activeCel = layer:cel(firstFrame)
        if not activeCel then
            return app.alert("No image on current frame/layer!")
            end

            local originalImage = activeCel.image:clone()
            local celPosX = activeCel.position.x
            local celPosY = activeCel.position.y

            local dlg = Dialog("Wave Warp v0.5")

            local function updatePreview()
            if not activeCel then return end
                if dlg.data.preview then
                    local args = dlg.data
                    args.celPosX = celPosX
                    args.celPosY = celPosY

                    local img, pad = getWarpedImage(originalImage, 0, args)

                    activeCel.image = img
                    activeCel.position = Point(celPosX - pad, celPosY - pad)
                    app.refresh()
                    else
                        activeCel.image = originalImage
                        activeCel.position = Point(celPosX, celPosY)
                        app.refresh()
                        end
                        end

                        dlg:separator{ text="Primary Wave Settings" }
                        dlg:slider{ id="amp", label="Height (Amp):", min=0, max=100, value=13, onchange=updatePreview }
                        dlg:slider{ id="width", label="Width (Freq):", min=1, max=200, value=50, onchange=updatePreview }
                        dlg:slider{ id="dir", label="Direction:", min=0, max=360, value=90, onchange=updatePreview }
                        dlg:slider{ id="cycles", label="Cycles/Loop:", min=-10, max=10, value=1, onchange=updatePreview }

                        dlg:separator{ text="Secondary Wave (Chaos/Bubbling)" }
                        dlg:check{ id="useSec", label="Enable Sec. Wave:", selected=true, onclick=updatePreview }
                        dlg:slider{ id="amp2", label="Sec. Height:", min=0, max=100, value=4, onchange=updatePreview }
                        dlg:slider{ id="width2", label="Sec. Width:", min=1, max=200, value=20, onchange=updatePreview }
                        dlg:slider{ id="dir2", label="Sec. Direction:", min=0, max=360, value=135, onchange=updatePreview }
                        dlg:slider{ id="cycles2", label="Sec. Cycles:", min=-10, max=10, value=2, onchange=updatePreview }

                        dlg:separator{ text="General & Animation" }
                        dlg:combobox{ id="pin", label="Pinning:", option="Left", options={"None", "Left", "Right", "Top", "Bottom"}, onchange=updatePreview }
                        dlg:number{ id="frames", label="Frame Count:", text="16", decimals=0 }
                        dlg:check{ id="preview", label="Live Preview (1st Frame)", selected=false, onclick=updatePreview }

                        function getWarpedImage(sourceImage, frameIndex, args)
                        local w = sourceImage.width
                        local h = sourceImage.height

                        local pad2 = args.useSec and args.amp2 or 0
                        local pad = math.ceil(args.amp + pad2)
                        local destW = w + (pad * 2)
                        local destH = h + (pad * 2)
                        local destImage = Image(destW, destH, sourceImage.colorMode)

                        local hasSelection = not sprite.selection.isEmpty
                        local sel = sprite.selection
                        local cX = args.celPosX or 0
                        local cY = args.celPosY or 0

                        local totalFrames = math.max(1, args.frames)

                        local amp = args.amp
                        local wavelength = args.width
                        if wavelength == 0 then wavelength = 1 end
                            local time = (frameIndex / totalFrames) * (args.cycles * 2 * math.pi)

                            local amp2 = args.amp2
                            local wavelength2 = args.width2
                            if wavelength2 == 0 then wavelength2 = 1 end
                                local time2 = (frameIndex / totalFrames) * (args.cycles2 * 2 * math.pi)

                                local pin = args.pin

                                local angle = math.rad(args.dir)
                                local cosA = math.cos(angle)
                                local sinA = math.sin(angle)

                                local angle2 = math.rad(args.dir2)
                                local cosA2 = math.cos(angle2)
                                local sinA2 = math.sin(angle2)

                                for y = 0, destH - 1 do
                                    for x = 0, destW - 1 do
                                        local rx = x - pad
                                        local ry = y - pad

                                        local inSelection = true
                                        if hasSelection then
                                            inSelection = sel:contains(rx + cX, ry + cY)
                                            end

                                            if inSelection then

                                                local dist = (rx * cosA) + (ry * sinA)
                                                local waveInput = (dist * 2 * math.pi / wavelength) - time
                                                local offset = math.sin(waveInput) * amp


                                                local offset2 = 0
                                                if args.useSec then
                                                    local dist2 = (rx * cosA2) + (ry * sinA2)
                                                    local waveInput2 = (dist2 * 2 * math.pi / wavelength2) - time2
                                                    offset2 = math.sin(waveInput2) * amp2
                                                    end

                                                    -- Pinning Logic
                                                    local pinX = math.max(0, math.min(1, rx / w))
                                                    local pinY = math.max(0, math.min(1, ry / h))

                                                    local scale = 1.0
                                                    if pin == "Left" then scale = pinX
                                                        elseif pin == "Right" then scale = 1.0 - pinX
                                                            elseif pin == "Top" then scale = pinY
                                                                elseif pin == "Bottom" then scale = 1.0 - pinY
                                                                    end


                                                                    local finalOffset = offset * scale
                                                                    local finalOffset2 = offset2 * scale


                                                                    local dispX1 = finalOffset * -sinA
                                                                    local dispY1 = finalOffset * cosA

                                                                    local dispX2 = finalOffset2 * -sinA2
                                                                    local dispY2 = finalOffset2 * cosA2


                                                                    local srcX = math.floor(rx - (dispX1 + dispX2) + 0.5)
                                                                    local srcY = math.floor(ry - (dispY1 + dispY2) + 0.5)

                                                                    if srcX >= 0 and srcX < w and srcY >= 0 and srcY < h then
                                                                        destImage:drawPixel(x, y, sourceImage:getPixel(srcX, srcY))
                                                                        end
                                                                        else
                                                                            if rx >= 0 and rx < w and ry >= 0 and ry < h then
                                                                                destImage:drawPixel(x, y, sourceImage:getPixel(rx, ry))
                                                                                end
                                                                                end
                                                                                end
                                                                                end

                                                                                return destImage, pad
                                                                                end

                                                                                local function runWarp(args)
                                                                                app.transaction("Wave Warp Generate", function()
                                                                                local framesToAdd = args.frames

                                                                                for i = 0, framesToAdd - 1 do
                                                                                    local targetFrameNum = firstFrame.frameNumber + i
                                                                                    local frameObj = sprite.frames[targetFrameNum]

                                                                                    if not frameObj then
                                                                                        frameObj = sprite:newEmptyFrame(targetFrameNum)
                                                                                        end

                                                                                        args.celPosX = celPosX
                                                                                        args.celPosY = celPosY
                                                                                        local warpedImg, pad = getWarpedImage(originalImage, i, args)
                                                                                        local targetPos = Point(celPosX - pad, celPosY - pad)

                                                                                        local targetCel = layer:cel(frameObj)
                                                                                        if targetCel then
                                                                                            targetCel.image = warpedImg
                                                                                            targetCel.position = targetPos
                                                                                            else
                                                                                                sprite:newCel(layer, frameObj, warpedImg, targetPos)
                                                                                                end
                                                                                                end
                                                                                                end)
                                                                                app.refresh()
                                                                                end

                                                                                local isOk = false
                                                                                local finalData = nil

                                                                                dlg:button{
                                                                                    id="ok",
                                                                                    text="Generate",
                                                                                    onclick=function()
                                                                                    if dlg.data.frames < 1 then return app.alert("Frame count must be at least 1") end
                                                                                        isOk = true
                                                                                        finalData = dlg.data
                                                                                        dlg:close()
                                                                                        end
                                                                                }
                                                                                dlg:button{ id="cancel", text="Cancel", onclick=function() dlg:close() end }

                                                                                dlg:show{ wait=true }


                                                                                if activeCel and originalImage then
                                                                                    pcall(function()
                                                                                    activeCel.image = originalImage
                                                                                    activeCel.position = Point(celPosX, celPosY)
                                                                                    end)
                                                                                    app.refresh()
                                                                                    end

                                                                                    if isOk then
                                                                                        runWarp(finalData)
                                                                                        end
