const MY_WORKCHAIN = BASECHAIN;
const OP_VOTE_YES = stringCrc32("vote_yes"); // 1b23c447
const OP_VOTE_NO = stringCrc32("vote_no");   // 4a82e299

var votesYes: int = 0;
var votesNo: int = 0;

fun voteYesAction() {
    votesYes += 1;
}

fun voteNoAction() {
    votesNo += 1;
}

fun routeInternal(`ctx::sender`: slice, `ctx::value`: int, `ctx::fwd_fee`: int, `ctx::body`: slice) {
    var (op: int, _) = `ctx::body`.loadOpAndQueryId();

    if (op == OP_VOTE_YES) {
        voteYesAction();
        return;
    }

    if (op == OP_VOTE_NO) {
        voteNoAction();
        return;
    }

    throw 0xffff;
}

fun main(`ctx::value`: int, inMsgFull: cell, `ctx::body`: slice) {
    var s = inMsgFull.beginParse();
    var flags = s.loadMsgFlags();
    if (isBounced(flags)) { return; }

    var (`ctx::sender`: slice, `ctx::fwd_fee`: int) = s.retrieveCtx(MY_WORKCHAIN);
    routeInternal(`ctx::sender`, `ctx::value`, `ctx::fwd_fee`, `ctx::body`);
}
