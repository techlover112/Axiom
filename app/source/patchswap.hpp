#pragma once

#include "common.hpp"

namespace PatchSwap
{
    struct ManifestEntry {
        char filename[64];
        char dest[128];
        char url[192];
        char sha256[65];
    };

    struct Manifest {
        char source[96];
        char release[32];
        char commit[41];
        char pulledAt[32];
        ManifestEntry files[12];
        int  fileCount;
    };

    bool CheckFreeSpace(MainStruct* mainStruct);

    bool HandoffExists();
    bool WriteHandoff();
    bool DeleteHandoff();

    bool BackupBrewtendoPatches(MainStruct* mainStruct);
    bool DownloadPretendoPatches(MainStruct* mainStruct, Manifest* manifestOut);
    bool DownloadBrewtendoPatches(MainStruct* mainStruct);

    bool MoveTempToLuma(MainStruct* mainStruct, Manifest* manifest = nullptr);
    bool RestoreFromBackup(MainStruct* mainStruct);

    bool SwitchToPretendo(MainStruct* mainStruct, Manifest* manifestOut);
    bool SwitchToBrewtendo(MainStruct* mainStruct);

    void DrawManifestInfo(const Manifest& manifest);
}
