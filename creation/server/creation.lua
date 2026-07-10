local L0_1, L1_1, L2_1
function L0_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L0_2 = 0
  L1_2 = pairs
  L2_2 = Beds
  L1_2, L2_2, L3_2, L4_2 = L1_2(L2_2)
  for L5_2, L6_2 in L1_2, L2_2, L3_2, L4_2 do
    L7_2 = L6_2.id
    if L0_2 < L7_2 then
      L0_2 = L6_2.id
    end
  end
  L1_2 = L0_2 + 1
  return L1_2
end
createId = L0_1
L0_1 = RegisterNetEvent
L1_1 = "ak47_qb_beds:addbed"
function L2_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L1_2 = createId
  L1_2 = L1_2()
  L2_2 = MySQL
  L2_2 = L2_2.Async
  L2_2 = L2_2.execute
  L3_2 = "INSERT INTO ak47_qb_beds (id, pos) VALUES (?, ?)"
  L4_2 = {}
  L5_2 = L1_2
  L6_2 = json
  L6_2 = L6_2.encode
  L7_2 = A0_2
  L6_2, L7_2, L8_2 = L6_2(L7_2)
  L4_2[1] = L5_2
  L4_2[2] = L6_2
  L4_2[3] = L7_2
  L4_2[4] = L8_2
  L2_2(L3_2, L4_2)
  L2_2 = Beds
  L3_2 = tostring
  L4_2 = L1_2
  L3_2 = L3_2(L4_2)
  L4_2 = {}
  L4_2.id = L1_2
  L4_2.pos = A0_2
  L2_2[L3_2] = L4_2
  L2_2 = TriggerClientEvent
  L3_2 = "ak47_qb_beds:addbed"
  L4_2 = -1
  L5_2 = tostring
  L6_2 = L1_2
  L5_2 = L5_2(L6_2)
  L6_2 = Beds
  L7_2 = tostring
  L8_2 = L1_2
  L7_2 = L7_2(L8_2)
  L6_2 = L6_2[L7_2]
  L2_2(L3_2, L4_2, L5_2, L6_2)
end
L0_1(L1_1, L2_1)
L0_1 = RegisterNetEvent
L1_1 = "ak47_qb_beds:remove"
function L2_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2
  L1_2 = MySQL
  L1_2 = L1_2.Async
  L1_2 = L1_2.execute
  L2_2 = "DELETE FROM ak47_qb_beds WHERE id = ?"
  L3_2 = {}
  L4_2 = A0_2
  L3_2[1] = L4_2
  L1_2(L2_2, L3_2)
  L1_2 = Beds
  L2_2 = tostring
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  L1_2[L2_2] = nil
  L1_2 = TriggerClientEvent
  L2_2 = "ak47_qb_beds:remove"
  L3_2 = -1
  L4_2 = tostring
  L5_2 = A0_2
  L4_2, L5_2 = L4_2(L5_2)
  L1_2(L2_2, L3_2, L4_2, L5_2)
end
L0_1(L1_1, L2_1)
