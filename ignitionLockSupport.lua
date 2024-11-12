ignitionLockSupport = {}

addModEventListener(ignitionLockSupport);

function ignitionLockSupport:loadMap(name)
    Enterable.onRegisterActionEvents = Utils.appendedFunction(Enterable.onRegisterActionEvents, ignitionLockSupport.registerActionEvents);
end

function ignitionLockSupport:registerActionEvents(isActiveForInput, isActiveForInputIgnoreSelection)
    if self.isClient then
        local spec = self.spec_motorized

        if isActiveForInputIgnoreSelection then
            local triggerKeyUp, triggerKeyDown, triggerAlways, isActive = false, true, false, true;
            InputBinding.registerActionEvent(g_inputBinding, InputAction["ilsMotorStart"], self, ignitionLockSupport.actionCallback, riggerKeyUp, triggerKeyDown, triggerAlways, isActive);
            InputBinding.registerActionEvent(g_inputBinding, InputAction["ilsMotorStop"], self, ignitionLockSupport.actionCallback, riggerKeyUp, triggerKeyDown, triggerAlways, isActive);

            Motorized.updateActionEvents(self)
        end

    end
end

function ignitionLockSupport:actionCallback(actionName, keyStatus, callbackState, isAnalog, isMouse, deviceCategory)
    if not self:getIsAIActive() then
        local spec = self.spec_motorized

        if actionName == "ilsMotorStart" then
            if self:getCanMotorRun() then
                Logging.info("[IgnitionLockSupport] startMotor")
                self:startMotor()
            else
                local warning = self:getMotorNotAllowedWarning()
                if warning ~= nil then
                    g_currentMission:showBlinkingWarning(warning, 2000)
                end
            end
        elseif actionName == "ilsMotorStop" and spec.isMotorStarted then
            Logging.info("[IgnitionLockSupport] stopMotor")
            self:stopMotor()
        end
    end
end