local L0_1, L1_1, L2_1
function L0_1(...)
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
  L0_2 = {}
  L1_2 = select
  L2_2 = "#"
  L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2 = ...
  L1_2 = L1_2(L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2)
  L2_2 = 1
  L3_2 = L1_2
  L4_2 = 1
  for L5_2 = L2_2, L3_2, L4_2 do
    L6_2 = select
    L7_2 = L5_2
    L8_2, L9_2, L10_2 = ...
    L6_2 = L6_2(L7_2, L8_2, L9_2, L10_2)
    L7_2 = Config
    L7_2 = L7_2.Creation
    L7_2 = L7_2.ActionControls
    L7_2 = L7_2[L6_2]
    L8_2 = table
    L8_2 = L8_2.insert
    L9_2 = L0_2
    L10_2 = L7_2
    L8_2(L9_2, L10_2)
  end
  return L0_2
end
GetControls = L0_1
function L0_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2
  L1_2 = Scaleforms
  L1_2 = L1_2.LoadMovie
  L2_2 = "INSTRUCTIONAL_BUTTONS"
  L1_2 = L1_2(L2_2)
  L2_2 = Scaleforms
  L2_2 = L2_2.PopVoid
  L3_2 = L1_2
  L4_2 = "CLEAR_ALL"
  L2_2(L3_2, L4_2)
  L2_2 = Scaleforms
  L2_2 = L2_2.PopInt
  L3_2 = L1_2
  L4_2 = "SET_CLEAR_SPACE"
  L5_2 = 200
  L2_2(L3_2, L4_2, L5_2)
  L2_2 = 1
  L3_2 = #A0_2
  L4_2 = 1
  for L5_2 = L2_2, L3_2, L4_2 do
    L6_2 = PushScaleformMovieFunction
    L7_2 = L1_2
    L8_2 = "SET_DATA_SLOT"
    L6_2(L7_2, L8_2)
    L6_2 = PushScaleformMovieFunctionParameterInt
    L7_2 = L5_2 - 1
    L6_2(L7_2)
    L6_2 = 1
    L7_2 = A0_2[L5_2]
    L7_2 = L7_2.codes
    L7_2 = #L7_2
    L8_2 = 1
    for L9_2 = L6_2, L7_2, L8_2 do
      L10_2 = _ENV
      L11_2 = "ScaleformMovieMethodAddParamPlayerNameString"
      L10_2 = L10_2[L11_2]
      L11_2 = GetControlInstructionalButton
      L12_2 = 0
      L13_2 = A0_2[L5_2]
      L13_2 = L13_2.codes
      L13_2 = L13_2[L9_2]
      L14_2 = true
      L11_2, L12_2, L13_2, L14_2 = L11_2(L12_2, L13_2, L14_2)
      L10_2(L11_2, L12_2, L13_2, L14_2)
    end
    L6_2 = BeginTextCommandScaleformString
    L7_2 = "STRING"
    L6_2(L7_2)
    L6_2 = AddTextComponentScaleform
    L7_2 = A0_2[L5_2]
    L7_2 = L7_2.label
    L6_2(L7_2)
    L6_2 = EndTextCommandScaleformString
    L6_2()
    L6_2 = PopScaleformMovieFunctionVoid
    L6_2()
  end
  L2_2 = Scaleforms
  L2_2 = L2_2.PopVoid
  L3_2 = L1_2
  L4_2 = "DRAW_INSTRUCTIONAL_BUTTONS"
  L2_2(L3_2, L4_2)
  return L1_2
end
CreateInstructional = L0_1
function L0_1(A0_2, A1_2, A2_2, A3_2, A4_2)
  local L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2
  L5_2 = CreateCamWithParams
  L6_2 = A0_2
  L7_2 = A1_2.x
  L8_2 = A1_2.y
  L9_2 = A1_2.z
  L10_2 = 0
  L11_2 = 0
  L12_2 = 0
  L13_2 = 50.0
  L5_2 = L5_2(L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2)
  L6_2 = SetCamCoord
  L7_2 = L5_2
  L8_2 = A1_2.x
  L9_2 = A1_2.y
  L10_2 = A1_2.z
  L6_2(L7_2, L8_2, L9_2, L10_2)
  L6_2 = SetCamRot
  L7_2 = L5_2
  L8_2 = A2_2.x
  L9_2 = A2_2.y
  L10_2 = A2_2.z
  L11_2 = 2
  L6_2(L7_2, L8_2, L9_2, L10_2, L11_2)
  if A3_2 then
    L6_2 = SetCamActive
    L7_2 = L5_2
    L8_2 = true
    L6_2(L7_2, L8_2)
    L6_2 = RenderScriptCams
    L7_2 = true
    L8_2 = false
    L9_2 = 0
    L10_2 = true
    L11_2 = false
    L6_2(L7_2, L8_2, L9_2, L10_2, L11_2)
  end
  if A4_2 then
    L6_2 = PointCamAtEntity
    L7_2 = L5_2
    L8_2 = A4_2
    L6_2(L7_2, L8_2)
  end
  return L5_2
end
CreateCamera = L0_1
function L0_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2
  L3_2 = GetCamCoord
  L4_2 = A0_2
  L3_2 = L3_2(L4_2)
  L4_2 = GetCamRot
  L5_2 = A0_2
  L6_2 = 2
  L4_2 = L4_2(L5_2, L6_2)
  L5_2 = GetFrameTime
  L5_2 = L5_2()
  L6_2 = Config
  L6_2 = L6_2.Creation
  L6_2 = L6_2.ActionControls
  L7_2 = Config
  L7_2 = L7_2.Creation
  L7_2 = L7_2.CameraOptions
  L8_2 = GetDisabledControlNormal
  L9_2 = 0
  L10_2 = 1
  L8_2 = L8_2(L9_2, L10_2)
  L9_2 = GetDisabledControlNormal
  L10_2 = 0
  L11_2 = 2
  L9_2 = L9_2(L10_2, L11_2)
  L10_2 = GetCamMatrix
  L11_2 = A0_2
  L10_2, L11_2, L12_2, L13_2 = L10_2(L11_2)
  L14_2 = vector3
  L15_2 = 0.0
  L16_2 = 0.0
  L17_2 = 1.0
  L14_2 = L14_2(L15_2, L16_2, L17_2)
  L15_2 = norm
  L16_2 = vector3
  L17_2 = L10_2.x
  L18_2 = L10_2.y
  L19_2 = 0.0
  L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2 = L16_2(L17_2, L18_2, L19_2)
  L15_2 = L15_2(L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2)
  L16_2 = norm
  L17_2 = vector3
  L18_2 = L11_2.x
  L19_2 = L11_2.y
  L20_2 = 0.0
  L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2 = L17_2(L18_2, L19_2, L20_2)
  L16_2 = L16_2(L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2)
  L17_2 = GetFrameTime
  L17_2 = L17_2()
  L18_2 = IsDisabledControlPressed
  L19_2 = 0
  L20_2 = L6_2.up
  L20_2 = L20_2.codes
  L20_2 = L20_2[2]
  L18_2 = L18_2(L19_2, L20_2)
  if L18_2 then
    L18_2 = L7_2.climbSpeed
    L18_2 = L18_2 * L17_2
    L18_2 = L14_2 * L18_2
    L3_2 = L3_2 + L18_2
    didMove = true
  else
    L18_2 = IsDisabledControlPressed
    L19_2 = 0
    L20_2 = L6_2.up
    L20_2 = L20_2.codes
    L20_2 = L20_2[1]
    L18_2 = L18_2(L19_2, L20_2)
    if L18_2 then
      L18_2 = L7_2.climbSpeed
      L18_2 = L18_2 * L17_2
      L18_2 = L14_2 * L18_2
      L3_2 = L3_2 - L18_2
      didMove = true
    end
  end
  L18_2 = IsDisabledControlPressed
  L19_2 = 0
  L20_2 = L6_2.forward
  L20_2 = L20_2.codes
  L20_2 = L20_2[2]
  L18_2 = L18_2(L19_2, L20_2)
  if L18_2 then
    L18_2 = L7_2.moveSpeed
    L18_2 = L18_2 * L17_2
    L18_2 = L16_2 * L18_2
    L3_2 = L3_2 + L18_2
    didMove = true
  else
    L18_2 = IsDisabledControlPressed
    L19_2 = 0
    L20_2 = L6_2.forward
    L20_2 = L20_2.codes
    L20_2 = L20_2[1]
    L18_2 = L18_2(L19_2, L20_2)
    if L18_2 then
      L18_2 = L7_2.moveSpeed
      L18_2 = L18_2 * L17_2
      L18_2 = L16_2 * L18_2
      L3_2 = L3_2 - L18_2
      didMove = true
    end
  end
  L18_2 = IsDisabledControlPressed
  L19_2 = 0
  L20_2 = L6_2.right
  L20_2 = L20_2.codes
  L20_2 = L20_2[1]
  L18_2 = L18_2(L19_2, L20_2)
  if L18_2 then
    L18_2 = L7_2.moveSpeed
    L18_2 = L18_2 * L17_2
    L18_2 = L15_2 * L18_2
    L3_2 = L3_2 + L18_2
    didMove = true
  else
    L18_2 = IsDisabledControlPressed
    L19_2 = 0
    L20_2 = L6_2.right
    L20_2 = L20_2.codes
    L20_2 = L20_2[2]
    L18_2 = L18_2(L19_2, L20_2)
    if L18_2 then
      L18_2 = L7_2.moveSpeed
      L18_2 = L18_2 * L17_2
      L18_2 = L15_2 * L18_2
      L3_2 = L3_2 - L18_2
      didMove = true
    end
  end
  if 0.0 ~= L9_2 then
    L18_2 = math
    L18_2 = L18_2.max
    L19_2 = -80.0
    L20_2 = math
    L20_2 = L20_2.min
    L21_2 = 80.0
    L22_2 = L4_2.x
    L23_2 = L7_2.lookSpeedX
    L23_2 = L9_2 * L23_2
    L23_2 = L23_2 * L17_2
    L22_2 = L22_2 - L23_2
    L20_2 = L20_2(L21_2, L22_2)
    L18_2 = L18_2(L19_2, L20_2)
    L19_2 = vector3
    L20_2 = L18_2
    L21_2 = L4_2.y
    L22_2 = L4_2.z
    L19_2 = L19_2(L20_2, L21_2, L22_2)
    L4_2 = L19_2
    didRot = true
  end
  if 0.0 ~= L8_2 then
    L18_2 = vector3
    L19_2 = L4_2.x
    L20_2 = L4_2.y
    L21_2 = L4_2.z
    L22_2 = L7_2.lookSpeedY
    L22_2 = L8_2 * L22_2
    L22_2 = L22_2 * L17_2
    L21_2 = L21_2 - L22_2
    L18_2 = L18_2(L19_2, L20_2, L21_2)
    L4_2 = L18_2
    didRot = true
  end
  L18_2 = didMove
  if L18_2 then
    L18_2 = SetCamCoord
    L19_2 = A0_2
    L20_2 = L3_2
    L18_2(L19_2, L20_2)
  end
  L18_2 = didRot
  if L18_2 then
    L18_2 = SetCamRot
    L19_2 = A0_2
    L20_2 = L4_2
    L21_2 = 2
    L18_2(L19_2, L20_2, L21_2)
  end
  if A1_2 and A2_2 then
    L18_2 = L3_2 - A1_2
    L18_2 = #L18_2
    if A2_2 < L18_2 then
      L19_2 = norm
      L20_2 = L3_2 - A1_2
      L19_2 = L19_2(L20_2)
      L20_2 = L19_2 * A2_2
      L3_2 = A1_2 + L20_2
      L20_2 = SetCamCoord
      L21_2 = A0_2
      L22_2 = L3_2
      L20_2(L21_2, L22_2)
    end
  end
  L18_2 = L3_2
  L19_2 = L4_2
  return L18_2, L19_2
end
HandleFlyCam = L0_1
function L0_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2
  L1_2 = SetCamActive
  L2_2 = A0_2
  L3_2 = false
  L1_2(L2_2, L3_2)
  L1_2 = RenderScriptCams
  L2_2 = false
  L3_2 = false
  L4_2 = 0
  L5_2 = true
  L6_2 = false
  L1_2(L2_2, L3_2, L4_2, L5_2, L6_2)
  L1_2 = DestroyCam
  L2_2 = A0_2
  L1_2(L2_2)
  L1_2 = SetFocusEntity
  L2_2 = PlayerPedId
  L2_2, L3_2, L4_2, L5_2, L6_2 = L2_2()
  L1_2(L2_2, L3_2, L4_2, L5_2, L6_2)
end
DestroyFlyCam = L0_1
function L0_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2
  L1_2 = DrawScaleformMovieFullscreen
  L2_2 = A0_2
  L3_2 = 255
  L4_2 = 255
  L5_2 = 255
  L6_2 = 255
  L1_2(L2_2, L3_2, L4_2, L5_2, L6_2)
end
DrawScaleform = L0_1
function L0_1(A0_2, A1_2, A2_2, A3_2, A4_2, A5_2, A6_2)
  local L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2
  L7_2 = {}
  L8_2 = A0_2.x
  L9_2 = A1_2.x
  L9_2 = L9_2 * A2_2
  L8_2 = L8_2 + L9_2
  L7_2.x = L8_2
  L8_2 = A0_2.y
  L9_2 = A1_2.y
  L9_2 = L9_2 * A2_2
  L8_2 = L8_2 + L9_2
  L7_2.y = L8_2
  L8_2 = A0_2.z
  L9_2 = A1_2.z
  L9_2 = L9_2 * A2_2
  L8_2 = L8_2 + L9_2
  L7_2.z = L8_2
  L8_2 = DrawLine
  L9_2 = A0_2.x
  L10_2 = A0_2.y
  L11_2 = A0_2.z
  L12_2 = L7_2.x
  L13_2 = L7_2.y
  L14_2 = L7_2.z
  L15_2 = A3_2
  L16_2 = A4_2
  L17_2 = A5_2
  L18_2 = A6_2
  L8_2(L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2)
end
drawLine = L0_1
function L0_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2, L31_2, L32_2, L33_2, L34_2, L35_2, L36_2, L37_2, L38_2, L39_2, L40_2, L41_2, L42_2
  L1_2 = ClonePed
  L2_2 = PlayerPedId
  L2_2 = L2_2()
  L3_2 = false
  L1_2 = L1_2(L2_2, L3_2)
  L2_2 = SetEntityAlpha
  L3_2 = L1_2
  L4_2 = 200
  L2_2(L3_2, L4_2)
  L2_2 = 0.0
  L3_2 = nil
  L4_2 = GetEntityMatrix
  L5_2 = L1_2
  L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2)
  L8_2 = L6_2 * 2
  L8_2 = L7_2 + L8_2
  L9_2 = vector3
  L10_2 = -35.0
  L11_2 = 0.0
  L12_2 = 0.0
  L9_2 = L9_2(L10_2, L11_2, L12_2)
  L10_2 = nil
  L11_2 = CreateCamera
  L12_2 = "DEFAULT_SCRIPTED_CAMERA"
  L13_2 = L8_2
  L14_2 = L9_2
  L15_2 = true
  L11_2 = L11_2(L12_2, L13_2, L14_2, L15_2)
  L12_2 = GetControls
  L13_2 = "enter"
  L14_2 = "up"
  L15_2 = "right"
  L16_2 = "forward"
  L17_2 = "rotate_z_scroll"
  L12_2 = L12_2(L13_2, L14_2, L15_2, L16_2, L17_2)
  L13_2 = CreateInstructional
  L14_2 = L12_2
  L13_2 = L13_2(L14_2)
  L14_2 = SetEntityCollision
  L15_2 = L1_2
  L16_2 = false
  L17_2 = false
  L14_2(L15_2, L16_2, L17_2)
  L14_2 = lib
  L14_2 = L14_2.requestAnimDict
  L15_2 = "timetable@tracy@sleep@"
  L14_2(L15_2)
  L14_2 = TaskPlayAnim
  L15_2 = L1_2
  L16_2 = "timetable@tracy@sleep@"
  L17_2 = "base"
  L18_2 = 8.0
  L19_2 = 8.0
  L20_2 = -1
  L21_2 = 1
  L14_2(L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2)
  L14_2 = GetCamMatrix
  L15_2 = L11_2
  L14_2, L15_2, L16_2, L17_2 = L14_2(L15_2)
  L18_2 = _ENV
  L19_2 = "StartExpensiveSynchronousShapeTestLosProbe"
  L18_2 = L18_2[L19_2]
  L19_2 = L17_2.x
  L20_2 = L17_2.y
  L21_2 = L17_2.z
  L22_2 = L17_2.x
  L23_2 = L15_2.x
  L23_2 = L23_2 * 100.0
  L22_2 = L22_2 + L23_2
  L23_2 = L17_2.y
  L24_2 = L15_2.y
  L24_2 = L24_2 * 100.0
  L23_2 = L23_2 + L24_2
  L24_2 = L17_2.z
  L25_2 = L15_2.z
  L25_2 = L25_2 * 100.0
  L24_2 = L24_2 + L25_2
  L25_2 = 1
  L26_2 = PlayerPedId
  L26_2 = L26_2()
  L27_2 = 4
  L18_2 = L18_2(L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2)
  L19_2 = GetShapeTestResult
  L20_2 = L18_2
  L19_2, L20_2, L21_2, L22_2, L23_2 = L19_2(L20_2)
  L24_2 = true
  L25_2 = true
  while L24_2 do
    L26_2 = Wait
    L27_2 = 0
    L26_2(L27_2)
    L26_2 = GetFrameTime
    L26_2 = L26_2()
    L27_2 = IsDisabledControlJustPressed
    L28_2 = 0
    L29_2 = Config
    L29_2 = L29_2.Creation
    L29_2 = L29_2.ActionControls
    L29_2 = L29_2.enter
    L29_2 = L29_2.codes
    L29_2 = L29_2[1]
    L27_2 = L27_2(L28_2, L29_2)
    if L27_2 then
      L27_2 = EnableAllControlActions
      L28_2 = 0
      L27_2(L28_2)
      L27_2 = FreezeEntityPosition
      L28_2 = L1_2
      L29_2 = true
      L27_2(L28_2, L29_2)
      L24_2 = false
    end
    L27_2 = GetCamMatrix
    L28_2 = L11_2
    L27_2, L28_2, L29_2, L30_2 = L27_2(L28_2)
    L17_2 = L30_2
    L16_2 = L29_2
    L15_2 = L28_2
    L14_2 = L27_2
    L27_2 = _ENV
    L28_2 = "StartExpensiveSynchronousShapeTestLosProbe"
    L27_2 = L27_2[L28_2]
    L28_2 = L17_2.x
    L29_2 = L17_2.y
    L30_2 = L17_2.z
    L31_2 = L17_2.x
    L32_2 = L15_2.x
    L32_2 = L32_2 * 100.0
    L31_2 = L31_2 + L32_2
    L32_2 = L17_2.y
    L33_2 = L15_2.y
    L33_2 = L33_2 * 100.0
    L32_2 = L32_2 + L33_2
    L33_2 = L17_2.z
    L34_2 = L15_2.z
    L34_2 = L34_2 * 100.0
    L33_2 = L33_2 + L34_2
    L34_2 = 1
    L35_2 = PlayerPedId
    L35_2 = L35_2()
    L36_2 = 4
    L27_2 = L27_2(L28_2, L29_2, L30_2, L31_2, L32_2, L33_2, L34_2, L35_2, L36_2)
    L18_2 = L27_2
    L27_2 = GetShapeTestResult
    L28_2 = L18_2
    L27_2, L28_2, L29_2, L30_2, L31_2 = L27_2(L28_2)
    L23_2 = L31_2
    L22_2 = L30_2
    L21_2 = L29_2
    L20_2 = L28_2
    L19_2 = L27_2
    L27_2 = IsDisabledControlJustPressed
    L28_2 = 0
    L29_2 = Config
    L29_2 = L29_2.Creation
    L29_2 = L29_2.ActionControls
    L29_2 = L29_2.rotate_z_scroll
    L29_2 = L29_2.codes
    L29_2 = L29_2[1]
    L27_2 = L27_2(L28_2, L29_2)
    if L27_2 then
      L2_2 = L2_2 + 10.0
    end
    L27_2 = IsDisabledControlJustPressed
    L28_2 = 0
    L29_2 = Config
    L29_2 = L29_2.Creation
    L29_2 = L29_2.ActionControls
    L29_2 = L29_2.rotate_z_scroll
    L29_2 = L29_2.codes
    L29_2 = L29_2[2]
    L27_2 = L27_2(L28_2, L29_2)
    if L27_2 then
      L2_2 = L2_2 - 10.0
    end
    L27_2 = DisableAllControlActions
    L28_2 = 0
    L27_2(L28_2)
    L27_2 = HandleFlyCam
    L28_2 = L11_2
    L27_2, L28_2 = L27_2(L28_2)
    L9_2 = L28_2
    L8_2 = L27_2
    L27_2 = vector3
    L28_2 = L21_2.x
    L29_2 = L21_2.y
    L30_2 = L21_2.z
    L30_2 = L30_2 + 1.0
    L27_2 = L27_2(L28_2, L29_2, L30_2)
    L3_2 = L27_2
    L27_2 = DrawText3Ds
    L28_2 = L21_2.x
    L29_2 = L21_2.y
    L30_2 = L21_2.z
    L30_2 = L30_2 + 1.0
    L31_2 = A0_2
    L32_2 = true
    L27_2(L28_2, L29_2, L30_2, L31_2, L32_2)
    L27_2 = DrawLine
    L28_2 = L21_2.x
    L29_2 = L21_2.y
    L30_2 = L21_2.z
    L31_2 = L21_2.x
    L32_2 = L21_2.y
    L33_2 = L21_2.z
    L33_2 = L33_2 + 2.0
    L34_2 = 255
    L35_2 = 0
    L36_2 = 0
    L37_2 = 255
    L27_2(L28_2, L29_2, L30_2, L31_2, L32_2, L33_2, L34_2, L35_2, L36_2, L37_2)
    L27_2 = SetEntityCoordsNoOffset
    L28_2 = L1_2
    L29_2 = L21_2.x
    L30_2 = L21_2.y
    L31_2 = L21_2.z
    L31_2 = L31_2 + 1.0
    L27_2(L28_2, L29_2, L30_2, L31_2)
    L27_2 = SetEntityHeading
    L28_2 = L1_2
    L29_2 = L2_2
    L27_2(L28_2, L29_2)
    L27_2 = DrawScaleform
    L28_2 = L13_2
    L27_2(L28_2)
  end
  L26_2 = vector3
  L27_2 = 0
  L28_2 = 0
  L29_2 = 1.0
  L26_2 = L26_2(L27_2, L28_2, L29_2)
  L21_2 = L21_2 + L26_2
  L26_2 = SetEntityCoordsNoOffset
  L27_2 = L1_2
  L28_2 = L21_2.x
  L29_2 = L21_2.y
  L30_2 = L21_2.z
  L26_2(L27_2, L28_2, L29_2, L30_2)
  L26_2 = GetControls
  L27_2 = "enter"
  L28_2 = "mouse1"
  L29_2 = "up"
  L30_2 = "right"
  L31_2 = "forward"
  L32_2 = "rotate_z_scroll"
  L26_2 = L26_2(L27_2, L28_2, L29_2, L30_2, L31_2, L32_2)
  L27_2 = CreateInstructional
  L28_2 = L26_2
  L27_2 = L27_2(L28_2)
  L28_2 = 1.0
  while L25_2 do
    L29_2 = Wait
    L30_2 = 0
    L29_2(L30_2)
    L29_2 = GetFrameTime
    L29_2 = L29_2()
    L30_2 = math
    L30_2 = L30_2.sin
    L31_2 = math
    L31_2 = L31_2.rad
    L32_2 = L2_2
    L31_2, L32_2, L33_2, L34_2, L35_2, L36_2, L37_2, L38_2, L39_2, L40_2, L41_2, L42_2 = L31_2(L32_2)
    L30_2 = L30_2(L31_2, L32_2, L33_2, L34_2, L35_2, L36_2, L37_2, L38_2, L39_2, L40_2, L41_2, L42_2)
    L30_2 = -L30_2
    L31_2 = math
    L31_2 = L31_2.cos
    L32_2 = math
    L32_2 = L32_2.rad
    L33_2 = L2_2
    L32_2, L33_2, L34_2, L35_2, L36_2, L37_2, L38_2, L39_2, L40_2, L41_2, L42_2 = L32_2(L33_2)
    L31_2 = L31_2(L32_2, L33_2, L34_2, L35_2, L36_2, L37_2, L38_2, L39_2, L40_2, L41_2, L42_2)
    L32_2 = {}
    L32_2.x = L30_2
    L32_2.y = L31_2
    L32_2.z = 0
    L33_2 = {}
    L34_2 = L32_2.y
    L33_2.x = L34_2
    L34_2 = L32_2.x
    L34_2 = -L34_2
    L33_2.y = L34_2
    L33_2.z = 0
    L34_2 = {}
    L34_2.x = 0
    L34_2.y = 0
    L34_2.z = 1
    L35_2 = drawLine
    L36_2 = vector3
    L37_2 = 0
    L38_2 = 0
    L39_2 = -0.5
    L36_2 = L36_2(L37_2, L38_2, L39_2)
    L36_2 = L21_2 + L36_2
    L37_2 = L32_2
    L38_2 = 2
    L39_2 = 255
    L40_2 = 0
    L41_2 = 0
    L42_2 = 255
    L35_2(L36_2, L37_2, L38_2, L39_2, L40_2, L41_2, L42_2)
    L35_2 = drawLine
    L36_2 = vector3
    L37_2 = 0
    L38_2 = 0
    L39_2 = -0.5
    L36_2 = L36_2(L37_2, L38_2, L39_2)
    L36_2 = L21_2 + L36_2
    L37_2 = L33_2
    L38_2 = 2
    L39_2 = 0
    L40_2 = 255
    L41_2 = 0
    L42_2 = 255
    L35_2(L36_2, L37_2, L38_2, L39_2, L40_2, L41_2, L42_2)
    L35_2 = drawLine
    L36_2 = vector3
    L37_2 = 0
    L38_2 = 0
    L39_2 = -0.5
    L36_2 = L36_2(L37_2, L38_2, L39_2)
    L36_2 = L21_2 + L36_2
    L37_2 = L34_2
    L38_2 = 2
    L39_2 = 0
    L40_2 = 0
    L41_2 = 255
    L42_2 = 255
    L35_2(L36_2, L37_2, L38_2, L39_2, L40_2, L41_2, L42_2)
    L35_2 = IsDisabledControlJustPressed
    L36_2 = 0
    L37_2 = Config
    L37_2 = L37_2.Creation
    L37_2 = L37_2.ActionControls
    L37_2 = L37_2.enter
    L37_2 = L37_2.codes
    L37_2 = L37_2[1]
    L35_2 = L35_2(L36_2, L37_2)
    if L35_2 then
      L35_2 = EnableAllControlActions
      L36_2 = 0
      L35_2(L36_2)
      L35_2 = DestroyFlyCam
      L36_2 = L11_2
      L35_2(L36_2)
      L35_2 = DeleteEntity
      L36_2 = L1_2
      L35_2(L36_2)
      L25_2 = false
      L35_2 = L21_2
      L36_2 = L2_2
      return L35_2, L36_2
    end
    L35_2 = IsDisabledControlPressed
    L36_2 = 0
    L37_2 = Config
    L37_2 = L37_2.Creation
    L37_2 = L37_2.ActionControls
    L37_2 = L37_2.mouse1
    L37_2 = L37_2.codes
    L37_2 = L37_2[1]
    L35_2 = L35_2(L36_2, L37_2)
    if L35_2 then
      L35_2 = HandleFlyCam
      L36_2 = L11_2
      L35_2, L36_2 = L35_2(L36_2)
      L9_2 = L36_2
      L8_2 = L35_2
    else
      L35_2 = IsDisabledControlPressed
      L36_2 = 1
      L37_2 = 32
      L35_2 = L35_2(L36_2, L37_2)
      if L35_2 then
        L35_2 = GetOffsetFromEntityInWorldCoords
        L36_2 = L1_2
        L37_2 = 0
        L38_2 = L28_2 * L29_2
        L39_2 = 0
        L35_2 = L35_2(L36_2, L37_2, L38_2, L39_2)
        L21_2 = L35_2
        L35_2 = SetEntityCoordsNoOffset
        L36_2 = L1_2
        L37_2 = L21_2.x
        L38_2 = L21_2.y
        L39_2 = L21_2.z
        L35_2(L36_2, L37_2, L38_2, L39_2)
      end
      L35_2 = IsDisabledControlPressed
      L36_2 = 1
      L37_2 = 33
      L35_2 = L35_2(L36_2, L37_2)
      if L35_2 then
        L35_2 = GetOffsetFromEntityInWorldCoords
        L36_2 = L1_2
        L37_2 = 0
        L38_2 = -L28_2
        L38_2 = L38_2 * L29_2
        L39_2 = 0
        L35_2 = L35_2(L36_2, L37_2, L38_2, L39_2)
        L21_2 = L35_2
        L35_2 = SetEntityCoordsNoOffset
        L36_2 = L1_2
        L37_2 = L21_2.x
        L38_2 = L21_2.y
        L39_2 = L21_2.z
        L35_2(L36_2, L37_2, L38_2, L39_2)
      end
      L35_2 = IsDisabledControlPressed
      L36_2 = 1
      L37_2 = 34
      L35_2 = L35_2(L36_2, L37_2)
      if L35_2 then
        L35_2 = GetOffsetFromEntityInWorldCoords
        L36_2 = L1_2
        L37_2 = -L28_2
        L37_2 = L37_2 * L29_2
        L38_2 = 0
        L39_2 = 0
        L35_2 = L35_2(L36_2, L37_2, L38_2, L39_2)
        L21_2 = L35_2
        L35_2 = SetEntityCoordsNoOffset
        L36_2 = L1_2
        L37_2 = L21_2.x
        L38_2 = L21_2.y
        L39_2 = L21_2.z
        L35_2(L36_2, L37_2, L38_2, L39_2)
      end
      L35_2 = IsDisabledControlPressed
      L36_2 = 1
      L37_2 = 35
      L35_2 = L35_2(L36_2, L37_2)
      if L35_2 then
        L35_2 = GetOffsetFromEntityInWorldCoords
        L36_2 = L1_2
        L37_2 = L28_2 * L29_2
        L38_2 = 0
        L39_2 = 0
        L35_2 = L35_2(L36_2, L37_2, L38_2, L39_2)
        L21_2 = L35_2
        L35_2 = SetEntityCoordsNoOffset
        L36_2 = L1_2
        L37_2 = L21_2.x
        L38_2 = L21_2.y
        L39_2 = L21_2.z
        L35_2(L36_2, L37_2, L38_2, L39_2)
      end
      L35_2 = IsDisabledControlPressed
      L36_2 = 1
      L37_2 = 44
      L35_2 = L35_2(L36_2, L37_2)
      if L35_2 then
        L35_2 = GetOffsetFromEntityInWorldCoords
        L36_2 = L1_2
        L37_2 = 0
        L38_2 = 0
        L39_2 = L28_2 * L29_2
        L35_2 = L35_2(L36_2, L37_2, L38_2, L39_2)
        L21_2 = L35_2
        L35_2 = SetEntityCoordsNoOffset
        L36_2 = L1_2
        L37_2 = L21_2.x
        L38_2 = L21_2.y
        L39_2 = L21_2.z
        L35_2(L36_2, L37_2, L38_2, L39_2)
      end
      L35_2 = IsDisabledControlPressed
      L36_2 = 1
      L37_2 = 38
      L35_2 = L35_2(L36_2, L37_2)
      if L35_2 then
        L35_2 = GetOffsetFromEntityInWorldCoords
        L36_2 = L1_2
        L37_2 = 0
        L38_2 = 0
        L39_2 = -L28_2
        L39_2 = L39_2 * L29_2
        L35_2 = L35_2(L36_2, L37_2, L38_2, L39_2)
        L21_2 = L35_2
        L35_2 = SetEntityCoordsNoOffset
        L36_2 = L1_2
        L37_2 = L21_2.x
        L38_2 = L21_2.y
        L39_2 = L21_2.z
        L35_2(L36_2, L37_2, L38_2, L39_2)
      end
    end
    L35_2 = IsDisabledControlJustPressed
    L36_2 = 0
    L37_2 = Config
    L37_2 = L37_2.Creation
    L37_2 = L37_2.ActionControls
    L37_2 = L37_2.rotate_z_scroll
    L37_2 = L37_2.codes
    L37_2 = L37_2[1]
    L35_2 = L35_2(L36_2, L37_2)
    if L35_2 then
      L2_2 = L2_2 + 5.0
      L35_2 = SetEntityHeading
      L36_2 = L1_2
      L37_2 = L2_2
      L35_2(L36_2, L37_2)
    end
    L35_2 = IsDisabledControlJustPressed
    L36_2 = 0
    L37_2 = Config
    L37_2 = L37_2.Creation
    L37_2 = L37_2.ActionControls
    L37_2 = L37_2.rotate_z_scroll
    L37_2 = L37_2.codes
    L37_2 = L37_2[2]
    L35_2 = L35_2(L36_2, L37_2)
    if L35_2 then
      L2_2 = L2_2 - 5.0
      L35_2 = SetEntityHeading
      L36_2 = L1_2
      L37_2 = L2_2
      L35_2(L36_2, L37_2)
    end
    L35_2 = DisableAllControlActions
    L36_2 = 0
    L35_2(L36_2)
    L35_2 = DrawScaleform
    L36_2 = L27_2
    L35_2(L36_2)
  end
end
SetupSleepPoint = L0_1
L0_1 = RegisterCommand
L1_1 = Config
L1_1 = L1_1.Commands
L1_1 = L1_1.createbed
function L2_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
  L2_2 = IsAdmin
  if L2_2 then
    L2_2 = SetupSleepPoint
    L3_2 = _U
    L4_2 = "setpos"
    L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2 = L3_2(L4_2)
    L2_2, L3_2 = L2_2(L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2)
    L4_2 = TriggerServerEvent
    L5_2 = "ak47_qb_beds:addbed"
    L6_2 = vector4
    L7_2 = L2_2.x
    L8_2 = L2_2.y
    L9_2 = L2_2.z
    L10_2 = L3_2
    L6_2, L7_2, L8_2, L9_2, L10_2 = L6_2(L7_2, L8_2, L9_2, L10_2)
    L4_2(L5_2, L6_2, L7_2, L8_2, L9_2, L10_2)
  else
    L2_2 = TriggerEvent
    L3_2 = "ak47_qb_beds:notify"
    L4_2 = _U
    L5_2 = "noaccess"
    L4_2 = L4_2(L5_2)
    L5_2 = "error"
    L2_2(L3_2, L4_2, L5_2)
  end
end
L0_1(L1_1, L2_1)
