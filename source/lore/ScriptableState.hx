package lore;

class ScriptableState extends MusicBeatState {
    public var script:FunkinHX = null;
    public var scriptName:String;
    var temp:FunkinHX->Void;
    override public function new(name:String, ?directory:String = "states", ?primer:FunkinHX->Void = null) {
        if (primer == null) {
            primer = this.primer;
        } else {
            temp = primer;
            primer = (f:FunkinHX) -> {
                this.primer(f);
                temp(f);
            }
        }
        scriptName = '${directory}/${name}.hx';
        if (sys.FileSystem.exists(Paths.modFolders(scriptName))) {
            script = new FunkinHX(Paths.modFolders(scriptName), primer);
        } else if (sys.FileSystem.exists(Paths.getPreloadPath(scriptName))) {
            script = new FunkinHX(Paths.getPreloadPath(scriptName), primer);
        } else {
            super();
            return;
        }
        super();
    }
    private function primer(script:FunkinHX):Void {
        script.remove("game");
        script.remove("add");
        script.remove("remove");
        script.remove("insert");
        script.remove("indexOf");
        script.remove("addBehindBF");
        script.remove("addBehindGF");
        script.remove("addBehindDad");
        script.remove("PlayState");
        script.set("state", this);
        script.set("controls", controls);
        script.set("add", add);
        script.set("remove", remove);
        script.set("insert", insert);
    }
    public override function create():Void {
        if (script != null) script.runFunc("create", []);
        super.create();
        if (script != null) script.runFunc("createPost", []);
    }
    public override function update(elapsed:Float):Void {
        if (flixel.FlxG.keys.justPressed.F8) MusicBeatState.switchState(Type.createInstance(CoolUtil.lastState, []));
        if (script != null) script.runFunc("update", [elapsed]);
        super.update(elapsed);
        if (script != null) script.runFunc("updatePost", [elapsed]);
    }
    public override function stepHit():Void {
        if (script != null) script.set("curStep", curStep);
        if (script != null) script.runFunc("stepHit", []);
        super.stepHit();
    }
    public override function beatHit():Void {
        if (script != null) script.set("curBeat", curBeat);
        if (script != null) script.runFunc("beatHit", []);
        super.beatHit();
    }
    public override function sectionHit():Void {
        if (script != null) script.set("curSection", curSection);
        if (script != null) script.runFunc("sectionHit", []);
        super.sectionHit();
    }
    public override function destroy():Void {
        if (script != null) script.runFunc("destroy", []);
        if (script != null) script.destroy();
        super.destroy();
    }
}

