require('constants')

require('weapons.weapon')
require('weapons.shotgun')
require('weapons.switcheroo')
require('weapons.machineGun')
require('weapons.frenzy')
require('weapons.tnt')
require('weapons.bombWeapon')
require('weapons.fling')
require('weapons.dispenserWeapon')
require('weapons.magnesis')
require('weapons.forcefield')
require('weapons.pocket')
require('weapons.basicGun')
require('weapons.basicMelee')

getWeaponIndexFromName = function (name)
    for i = 1, #weaponConstructors do
        temp = weaponConstructors[i]:new(0, 0)
        if temp.name == name then
            return i
        end
    end

    return NOT_FOUND
end