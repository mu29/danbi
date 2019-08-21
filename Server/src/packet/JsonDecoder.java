package packet;

import io.netty.buffer.ByteBuf;
import io.netty.channel.ChannelHandlerContext;
import io.netty.handler.codec.CorruptedFrameException;
import io.netty.handler.codec.string.StringDecoder;

import java.io.IOException;
import java.util.List;

import org.json.simple.JSONObject;

import com.fasterxml.jackson.core.JsonParseException;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.ObjectMapper;

public class JsonDecoder extends StringDecoder {
	@Override
    protected void decode(ChannelHandlerContext ctx, ByteBuf msg, List<Object> out) throws Exception {
    	if (msg.readableBytes() < 4) {
            return;
    	}
	    msg.markReaderIndex();
	    int dataLength = msg.readInt();
	    if (msg.readableBytes() < dataLength) {
            msg.resetReaderIndex();
            return;
	    }
	    byte[] decoded = new byte[dataLength];
	    msg.readBytes(decoded);
	    out.add(deserialize(decoded));
    }
	
    private Object deserialize(byte[] buf) throws CorruptedFrameException {
        ObjectMapper mapper = new ObjectMapper();
        Throwable t;
        try {
                return mapper.readValue(buf, JSONObject.class);
        } catch (JsonParseException e) {
                t = e;
        } catch (JsonMappingException e) {
                t = e;
        } catch (IOException e) {
                t = e;
        }
        throw new CorruptedFrameException("Error deserializing json: " + t.getMessage());
    }
}