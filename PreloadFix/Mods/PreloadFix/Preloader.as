import Peanuts.Audio.HazeAudioManager.AudioManagerStatics;
import Peanuts.Triggers.PlayerTrigger;
//import Mods.PreloadFix.UI.TooltipManager;

UPreloader GetPreloader() {
  	return Cast<UPreloader>(Game::GetSingleton(UPreloader::StaticClass()));
}

class UPreloader : UHazeSingleton {
    private FString Level = "";
    private bool PreloadQueued = true;

    UFUNCTION(BlueprintOverride)
    void Initialize() {
    }

    UFUNCTION(BlueprintOverride)
    void Tick(float DeltaTime) {
        Level = GetCurrentLevel();

        //GetTooltipManager().Tick(DeltaTime);

        if(Game::IsInLoadingScreen()) {
          QueuePreload();
        }

        if(!Game::IsInLoadingScreen() && PreloadQueued) {
            PreloadLevel();
            PreloadQueued = false;
        }

        //TArray<APlayerTrigger> T;
        //GetAllActorsOfClass(T);
        //for(int i = 0; i < T.Num(); i++) {
        //    APlayerTrigger TR = T[i];
        //    if(TR.IsOverlappingActor(Game::GetCody())) {
        //        if(GetTooltipManager().TimeSinceLastTooltip >= .1f)
		    //	  GetTooltipManager().DisplayMessage("Index: " + i + ", Position: " + TR.ActorLocation);
		    //	  break;
		    //  }
        //}

        if(Level == "/Game/Maps/SnowGlobe/Town/SnowGlobe_Town_BP") {
            TArray<APlayerTrigger> Triggers;
            GetAllActorsOfClass(Triggers);
          
			for(int i = 0; i < Triggers.Num(); i++) {
			    APlayerTrigger Trigger = Triggers[i];
			    if(
			    	(Trigger.ActorLocation == FVector(-56591.313f, 54446.484f, -36863.605f) || Trigger.ActorLocation == FVector(-56591.313, 54446.484, 63136.395f)) &&
			    	(Trigger.IsOverlappingActor(Game::GetCody()) || Trigger.IsOverlappingActor(Game::GetMay()))
			    ) {
			    	//GetTooltipManager().DisplayMessage("Index: " + i);
			    	Progress::PrepareProgressPoint("/Game/Maps/SnowGlobe/Lake/Snowglobe_Lake_BP##Entry", FHazePrepareDone(), true);
			    	break;
			    }
			}
        } else if(Level == "/Game/Maps/Tree/SquirrelHome/SquirrelHome_BP_Mech") {
            TArray<APlayerTrigger> Triggers;
            GetAllActorsOfClass(Triggers);

			for(int i = 0; i < Triggers.Num(); i++) {
			    APlayerTrigger Trigger = Triggers[i];
          		if(
			    	Trigger.ActorLocation == FVector(-104300.f, 27580.f, 53500.f) &&
			    	(Trigger.IsOverlappingActor(Game::GetCody()) || Trigger.IsOverlappingActor(Game::GetMay()))
			    ) {
			    	Progress::PreloadProgressPointFromDisk("/Game/Maps/Tree/WaspNest/WaspsNest_BP##Entry");
			    	break;
				}
          		if(
			    	Trigger.ActorLocation == FVector(-125030.f, 26880.f, 55160.f) &&
			    	(Trigger.IsOverlappingActor(Game::GetCody()) || Trigger.IsOverlappingActor(Game::GetMay()))
				) {
					Progress::ActivateProgressPoint("/Game/Maps/Tree/WaspNest/SquirrelHome/SquirrelHome_BP_Mech##Vault", true);
			    	Progress::PrepareProgressPoint("/Game/Maps/Tree/WaspNest/WaspsNest_BP##Entry", FHazePrepareDone(), true);
			    	break;
				}
			}
        }
    }

    void QueuePreload() {
        PreloadQueued = true;
    }

    void PreloadLevel() {
        if(Level == "/Game/Maps/SnowGlobe/Town/SnowGlobe_Town_BP") {
            Progress::PreloadProgressPointFromDisk("/Game/Maps/SnowGlobe/Lake/Snowglobe_Lake_BP##Entry");
        }
    }

}

FString GetCurrentLevel() {
    return GetAudioManager().CurrentInLevel;
}